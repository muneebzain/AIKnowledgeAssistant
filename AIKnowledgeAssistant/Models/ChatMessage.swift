//
//  ChatMessage.swift
//  AIKnowledgeAssistant
//
//  Created by Muneeb Zain on 28/02/2026.
//

import Foundation

struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    let isUser: Bool
    var text: String
    var isStreaming: Bool = false
}
