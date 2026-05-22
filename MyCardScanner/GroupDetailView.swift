//
//  GroupDetailView.swift
//  MyCardScanner
//
//  Created by 泉芳樹 on 2026/04/28.
//

import SwiftUI

struct GroupDetailView: View {
    var group: TagGroup
    var cards: [BusinessCard]
    
    var body: some View {
        List(filteredCards()) { card in
            Text(card.company)
        }
        .navigationTitle(group.name)
    }
    func normalize(_ text: String) -> String {
        return text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\n", with: "")
            .lowercased()
    }
    func filteredCards() -> [BusinessCard] {

        return cards.filter { card in

            card.tags.contains { tag in

                group.tags.contains { groupTag in

                    normalize(tag).contains(normalize(groupTag.tag))
                }

            }

        }

        .sorted { $0.company < $1.company }

    }
}
