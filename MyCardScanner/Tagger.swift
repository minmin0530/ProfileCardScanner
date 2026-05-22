//
//  Tagger.swift
//  MyCardScanner
//
//  Created by 泉芳樹 on 2026/04/26.
//

//class Tagger {
//    static func generateTags(from text: String) -> [String] {
//        var tags: [String] = []
//        
//        let lower = text.lowercased()
//        
//        if lower.contains("株式会社") { tags.append("企業") }
//        if lower.contains("代表") { tags.append("経営者") }
//        if lower.contains("営業") { tags.append("営業") }
//        if lower.contains("エンジニア") || lower.contains("it") { tags.append("IT") }
//        if lower.contains("学校") || lower.contains("教育") { tags.append("教育") }
//        
//        if tags.isEmpty {
//            tags.append("未分類")
//        }
//        
//        return tags
//    }
//}


class Tagger {
    static func generateTags(from text: String, groups: [TagGroup]) -> [String] {
        var tags: [String] = []
        let t = text.lowercased()
        
        
        for group in groups {
            for tag in group.tags {
                if t.contains(tag) {
                    tags.append(group.name)
                }
            }
        }
        
//        // 経営者
//        if t.contains("代表") || t.contains("ceo") || t.contains("社長") {
//            tags.append("経営者")
//        }
//        
//        // IT
//        if t.contains("エンジニア") || t.contains("developer") || t.contains("it") || t.contains("システム") {
//            tags.append("IT")
//        }
//        
//        // 営業
//        if t.contains("営業") || t.contains("sales") || t.contains("セールス") {
//            tags.append("営業")
//        }
//
//        // 税理士
//        if t.contains("税理士") || t.contains("tax accountant") || t.contains("tax counsellor") {
//            tags.append("税理士")
//        }
//
//        // 教育
//        if t.contains("学校") || t.contains("教育") || t.contains("スクール") {
//            tags.append("教育")
//        }
//        
//        // 会社
//        if t.contains("株式会社") || t.contains("有限会社") {
//            tags.append("企業")
//        }
//        
        if tags.isEmpty {
            tags.append("未分類")
        }
        
        return tags
    }
}
