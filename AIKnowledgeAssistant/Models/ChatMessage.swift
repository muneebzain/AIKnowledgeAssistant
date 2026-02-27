//
//  ChatMessage.swift
//  AIKnowledgeAssistant
//
//  Created by Muneeb Zain on 28/02/2026.
//

import Foundation

struct ChatMessage: Identifiable {
    let id = UUID()
    var text: String
    let isUser: Bool
}
