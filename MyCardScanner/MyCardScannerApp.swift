//
//  MyCardScannerApp.swift
//  MyCardScanner
//
//  Created by 泉芳樹 on 2026/04/26.
//

import SwiftUI
import UIKit

@main
struct MyCardScannerApp: App {
    
    var body: some Scene {
        WindowGroup {
            MyCardScannerApp2()
        }
    }
}


struct MyCardScannerApp2: View {
    @State private var cards: [BusinessCard] = []
    @State private var showCamera = false
    @State private var showAddGroup = false


    @State private var newGroupName = ""
    @State private var newTagName = ""
    @State private var groups: [TagGroup] = [
        TagGroup(
            name: "営業ターゲット",
            tags: [Line(tag: "経営者",button: ""), Line(tag: "営業",button: "")],
            colorHex: "007AFF"
        ),
        TagGroup(
            name: "技術系",
            tags: [Line(tag:"IT", button: ""), Line(tag:"エンジニア", button: "")],
            colorHex: "7AFF7A"
        ),
        TagGroup(
            name: "管理",
            tags: [
                Line(tag:"リーダー",button: ""),
                Line(tag:"マネージャー",button: ""),
                Line(tag:"課長",button: ""),
                Line(tag:"部長",button: "")
            ],
            colorHex: "FFFF7A"
        ),
        TagGroup(
            name: "未分類",
            tags: [Line(tag:"未分類",button: "")],
            colorHex: "7A7A7A"
        )
    ]
    
    func groupedCards() -> [String: [BusinessCard]] {
        var dict: [String: [BusinessCard]] = [:]
        
        for card in cards {
            for tag in card.tags {
                dict[tag, default: []].append(card)
            }
        }
        
        return dict
    }

    func groupedByTagGroup() -> [String: [BusinessCard]] {
        var result: [String: [BusinessCard]] = [:]
        
        for group in groups {
            var groupCards: [BusinessCard] = []
            
            for card in cards {
                for tag in card.tags {
                    if tag.contains(where: {
                        for gtag in group.tags {
                            return gtag.tag.contains($0)
                        }
                        return false
                    }) {
                        groupCards.append(card)
                    }
                }
            }
            
            result[group.name] = groupCards
        }
        
        return result
    }
    
    
    var body: some View {
        NavigationView {
            /*
            List {
                ForEach(groups) { group in
                    Section(header: Text(group.name)) {
                        let cardsInGroup = groupedByTagGroup()[group.name] ?? []
                        
                        ForEach(cardsInGroup) { card in
                            VStack(alignment: .leading) {
                                Text(card.company).font(.headline)
                                Text(card.rawText).font(.caption)
                            }
                        }
                    }
                }

                ForEach(groupedCards().keys.sorted(), id: \.self) { tag in

                    Section(header: Text(tag)) {

                        ForEach(groupedCards()[tag]!) { card in

                            VStack(alignment: .leading) {

                                Text(card.company).font(.headline)

                                Text(card.rawText).font(.caption)

                            }

                        }

                    }

                }

                ForEach(cards) { card in
                    VStack(alignment: .leading) {
                        Text(card.company).font(.headline)
                        Text(card.rawText).font(.caption)
                        
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(card.tags, id: \.self) { tag in
                                    Text(tag)
                                        .padding(6)
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(6)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("名刺管理AI")
            .toolbar {
                Button("カメラ") {
                    showCamera = true
                }
                Button("グループ") {
                    showAddGroup = true
                }
            }
            .sheet(isPresented: $showCamera) {
                MyCardScanner { image in
                    OCRService.recognizeText(from: image) { text in
                        let tags = Tagger.generateTags(from: text, groups: groups)
                        
                        let card = BusinessCard(
                            name: "",
                            company: extractCompany(from: text),
                            rawText: text,
                            tags: tags
                        )
                        
                        cards.append(card)
                    }
                }
            }
            .navigationTitle("タグ別一覧")
            .sheet(isPresented: $showAddGroup) {
                // 👇 グループ追加UI

                HStack {

                    TextField("グループ名", text: $newGroupName)
                    TextField("タグ名", text: $newTagName)

                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    

                    Button("追加") {

                        guard !newGroupName.isEmpty else { return }

                        

                        groups.append(TagGroup(name: newGroupName, tags: [ newTagName ]))

                        newGroupName = "" // 入力リセット

                    }

                }

                .padding()

                

                // 👇 グループ一覧表示
                NavigationView {
                    List {
                        
                        ForEach(groups) { group in
                            NavigationLink(destination: GroupDetailView(group: group, cards: cards)) {
                                
                                Text(group.name)
                            }
                            //                        Text(group.name)
                            
                        }
                        
                    }
                }
                .navigationTitle("グループ一覧")
            }
            .navigationTitle("タググループ")
*/
            TabView {

                HomeView(cards: cards, groups: groups)

                    .tabItem {

                        Image(systemName: "house.fill")

                        Text("ホーム")

                    }

                

                CardListView(cards: cards, groups: groups)

                    .tabItem {

                        Image(systemName: "creditcard")

                        Text("名刺一覧")

                    }
//                func testCode() {
//                    Text("testcode")
//                }

                ScanView(cards: $cards, groups: groups)

                    .tabItem {

                        Image(systemName: "viewfinder")

                        Text("スキャン")

                    }

                

                TagView(cards: $cards)
                    .tabItem {
                        Image(systemName: "tag")
                        Text("タグ")
                    }

                SettingsView(groups: $groups)
                    .tabItem {
                        Image(systemName: "gearshape")
                        Text("設定")
                    }
            }
        }
    }
    
    func extractCompany(from text: String) -> String {
        let lines = text.components(separatedBy: "\n")
        return lines.first ?? "不明"
    }

}

struct CardScanner: UIViewControllerRepresentable {
    @State var completion: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CardScanner
        
        init(_ parent: CardScanner) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.completion(image)
            }
            picker.dismiss(animated: true)
        }
    }
}

struct ScanView: View {

    @Binding var cards: [BusinessCard]
    var groups: [TagGroup]
    @State private var showCamera = false


    var body: some View {

        VStack {

            Button("名刺をスキャン") {

                showCamera = true

            }

        }

        .sheet(isPresented: $showCamera) {

            CardScanner { image in

                OCRService.recognizeText(from: image) { text in

                    

                    let tags = Tagger.generateTags(from: text, groups: groups)

                    

                    let card = BusinessCard(
                        name: "",
                        company: extractCompany(from: text),
                        rawText: text,
                        tags: tags,
                        manual: Line(tag: "manual", button: "ZZZZ")
                    )
                    cards.append(card) // ←ここが重要
                }
            }
        }
    }

    func extractCompany(from text: String) -> String {

        text.components(separatedBy: "\n").first ?? "不明"

    }

}

struct CardListView: View {
    var cards: [BusinessCard]
    var groups: [TagGroup]
    var body: some View {
        List(cards) { card in
            CardRow(card: card, groups: groups)
        }
    }
}

struct HomeView: View {
    var cards: [BusinessCard]
    var groups: [TagGroup]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("ダッシュボード")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    // 統計
                    HStack {
                        StatCard(
                            icon: "person.crop.rectangle",
                            title: "名刺",
                            value: "\(cards.count)",
                            color: .purple
                        )

                        StatCard(
                            icon: "tag",
                            title: "タグ",
                            value: "\(allTags().count)",
                            color: .green
                        )

                        StatCard(
                            icon: "person.3",
                            title: "グループ",
                            value: "\(groups.count)",
                            color: .orange
                        )
                        
                        
                    }
                    .padding(.horizontal)
                    
                    // グループ一覧
                    VStack(spacing: 12) {
                        ForEach(groups) { group in
                            NavigationLink {
                                GroupDetailView(group: group, cards: cards)
                            } label: {
                                GroupRow(
                                    name: group.name,
                                    tags: group.tags,
                                    count: countCards(group: group),
                                    color: Color.init(hex: group.colorHex)
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // 最近の名刺
                    VStack(spacing: 12) {
                        ForEach(cards.prefix(5)) { card in
                            CardRow(card: card, groups: groups)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    func countCards(group: TagGroup) -> Int {
        cards.filter { card in
            for tag in card.tags {
                return tag.contains(where: {
                    for gtag in group.tags {
                        return gtag.tag.contains($0)
                    }
                    return false
                })
            }
            return false
        }.count
    }
    func colorForGroup(_ name: String) -> Color {
        switch name {
        case "営業ターゲット": return .blue
        case "技術系": return .green
        case "管理": return .orange
        default: return .gray
        }
    }
    func allTags() -> Set<String> {
        Set(cards.flatMap { $0.tags })
    }
}
struct StatCard: View {
    var icon: String
    var title: String
    var value: String
    var color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.headline)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
}

struct SectionHeader: View {
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            
            Spacer()
            
            Text("すべて見る")
                .font(.caption)
                .foregroundColor(.blue)
        }
        .padding(.horizontal)
    }
}
struct GroupRow: View {
    
    var name: String
    var tags: [Line]
    var count: Int
    var color: Color
//    let count: countCards(group: group)
//    let color: colorForGroup(group.name)
    
    var body: some View {
        HStack {
            Circle()
                .fill(color.opacity(0.2))
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)
                
                HStack {
                    ForEach(tags) { tag in
                        Text(tag.tag)
                            .font(.caption)
                            .padding(4)
                            .background(color.opacity(0.2))
                            .cornerRadius(6)
                    }
                }
            }
            
            Spacer()
            
            Text("\(count)枚")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }

}

//struct CardRow: View {
//    var name: String
//    var company: String
//    var tag: String
//    
//    var body: some View {
//        HStack {
//            Rectangle()
//                .fill(Color.gray.opacity(0.2))
//                .frame(width: 60, height: 40)
//                .cornerRadius(6)
//            
//            VStack(alignment: .leading) {
//                Text(name)
//                    .font(.headline)
//                
//                Text(company)
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                
//                Text(tag)
//                    .font(.caption)
//                    .padding(4)
//                    .background(Color.blue.opacity(0.2))
//                    .cornerRadius(6)
//            }
//            
//            Spacer()
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(12)
//        .shadow(color: .black.opacity(0.05), radius: 5)
//    }
//}
struct CardRow: View {
    var card: BusinessCard
    var groups: [TagGroup]
    
    @State private var showDialog = false
    @State private var selectedText = "未選択"

    var body: some View {
        VStack(alignment: .leading) {
            Text(card.company)
                .font(.headline)
            
            
            ForEach (card.rawText.components(separatedBy: "\n"), id: \.self) { rawtext in
                Button(rawtext) {
                    showDialog = true
                }
                .confirmationDialog(

                            "項目を選択",

                            isPresented: $showDialog,

                            titleVisibility: .visible

                        ) {

                            Button("名前") {

                                selectedText = "りんご"

                            }

                            Button("住所") {

                                selectedText = "みかん"

                            }

                            Button("リンク") {

                                selectedText = "バナナ"

                            }
                            Button("メール") {

                                selectedText = "バナナ"

                            }

                            Button("キャンセル", role: .cancel) {

                            }

                        }
            }
            HStack {
                ForEach(card.tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(4)
                        .background(colorForGroup(tag).opacity(0.2))
                        .cornerRadius(6)
                }
            }
        }
    }
    func colorForGroup(_ name: String) -> Color {

        for group in groups {
            if group.name
                
                .contains(name) {
                    return Color.init(hex: group.colorHex)
                }
        }
        return .gray
    }
}


struct TagView: View {
    @Binding var cards: [BusinessCard]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(allTags(), id: \.self) { tag in
                    HStack {
                        Text(tag)
                        Spacer()
                        Text("\(count(tag))件")
                            .foregroundColor(.gray)
                    }
                }
                .onDelete(perform: deleteTag)
            }
            .navigationTitle("タグ管理")
            .toolbar {
                EditButton()
            }
        }
    }
    
    // 全タグ取得
    func allTags() -> [String] {
        Array(Set(cards.flatMap { $0.tags })).sorted()
    }
    
    // 件数
    func count(_ tag: String) -> Int {
        cards.filter { $0.tags.contains(tag) }.count
    }
    
    // タグ削除（全カードから消す）
    func deleteTag(at offsets: IndexSet) {
        let tags = allTags()
        
        for index in offsets {
            let tagToDelete = tags[index]
            
            for i in cards.indices {
                cards[i].tags.removeAll { $0 == tagToDelete }
            }
        }
    }
}


struct SettingsView: View {
    @Binding var groups: [TagGroup]
    
    @State private var newGroupName = ""
    @State private var newTag = Line(tag: "", button: "")
    @State private var tags: [Line] = []
    @State private var selectedColor: Color = .blue
    
    var body: some View {
        NavigationStack {
            VStack {
                
                // 名前
                TextField("グループ名", text: $newGroupName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                // タグ追加
                HStack {
                    TextField("タグ追加", text: $newTag.tag)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("追加") {
                        guard !newTag.tag.isEmpty else { return }
                        tags.append(newTag)
                        newTag = Line(tag: "", button: "")
                    }
                }
                .padding(.horizontal)
                
                // タグ一覧
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(tags) { tag in
                            Text(tag.tag)
                                .padding(6)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(6)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // 色選択
                ColorPicker("色を選択", selection: $selectedColor)
                    .padding()
                
                // 追加ボタン
                Button("グループ作成") {
                    guard !newGroupName.isEmpty else { return }
                    
                    let hex = selectedColor.toHex()
                    
                    let newGroup = TagGroup(
                        name: newGroupName,
                        tags: tags,
                        colorHex: hex
                    )
                    
                    groups.append(newGroup)
                    
                    // リセット
                    newGroupName = ""
                    tags = []
                    selectedColor = .blue
                }
                .padding()
                
                Divider()
                
                // 既存グループ一覧
                List {
                    ForEach(groups) { group in
                        HStack {
                            Circle()
                                .fill(Color(hex: group.colorHex))
                                .frame(width: 16, height: 16)
                            
                            Text(group.name)
                        }
                    }
                    .onDelete { indexSet in
                        groups.remove(atOffsets: indexSet)
                    }
                }
            }
            .navigationTitle("グループ設定")
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex
            .trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let r, g, b, a: UInt64
        
        switch hex.count {
        case 6: // RGB
            (r, g, b, a) = (
                (int >> 16) & 0xFF,
                (int >> 8) & 0xFF,
                int & 0xFF,
                255
            )
        case 8: // RGBA
            (r, g, b, a) = (
                (int >> 24) & 0xFF,
                (int >> 16) & 0xFF,
                (int >> 8) & 0xFF,
                int & 0xFF
            )
        default:
            (r, g, b, a) = (0, 0, 0, 255)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension Color {
    func toHex() -> String {
        let uiColor = UIColor(self)
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return "000000"
        }
        
        return String(
            format: "%02X%02X%02X",
            Int(r * 255),
            Int(g * 255),
            Int(b * 255)
        )
    }
}
