//
//  Line.swift
//  MyCardScanner
//
//  Created by 泉 芳樹 on 2026/05/22.
//

import Foundation

struct Line: Identifiable, Codable {
    var id = UUID()
    var tag: String
    var button: String
}
