//
//  ChatMessage.swift
//  AIKnowledgeAssistant
//
//  Created by Muneeb Zain on 28/02/2026.
//


import Foundation

struct ChatMessage: Identifiable, Codable, Equatable {
    enum Role: String, Codable {
        case user
        case assistant
        case system
    }

    let id: UUID
    let role: Role
    var text: String
    var isStreaming: Bool
    let createdAt: Date

    init(
        id: UUID = UUID(),
        role: Role,
        text: String,
        isStreaming: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.role = role
        self.text = text
        self.isStreaming = isStreaming
        self.createdAt = createdAt
    }
}
