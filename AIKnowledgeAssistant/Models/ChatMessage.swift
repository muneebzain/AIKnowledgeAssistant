//
//  ChatMessage.swift
//  AIKnowledgeAssistant
//
//  Created by Muneeb Zain on 28/02/2026.
//


import Foundation

struct ChatMessage: Identifiable, Codable, Equatable {
    let id: UUID
    let isUser: Bool
    var text: String
    var isStreaming: Bool
    let createdAt: Date

    init(
        id: UUID = UUID(),
        isUser: Bool,
        text: String,
        isStreaming: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.isUser = isUser
        self.text = text
        self.isStreaming = isStreaming
        self.createdAt = createdAt
    }
}
