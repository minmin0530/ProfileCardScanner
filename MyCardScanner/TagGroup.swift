//
//  TagGroup.swift
//  MyCardScanner
//
//  Created by 泉芳樹 on 2026/04/27.
//

import Foundation

struct TagGroup: Identifiable, Codable {
    var id = UUID()
    var name: String
    var tags: [Line] // このグループに属するタグ
    var colorHex: String   // ← 色はHexで管理（保存しやすい）
}
