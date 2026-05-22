//
//  Model.swift
//  MyCardScanner
//
//  Created by 泉芳樹 on 2026/04/26.
//

import Foundation

struct BusinessCard: Identifiable, Codable {
    var id = UUID()
    var name: String
    var company: String
    var rawText: String
    var tags: [String]
    var manual: Line
}
    
