//
//  ChatMemoryStore.swift
//  AIKnowledgeAssistant
//
//  Created by Muneeb Zain on 01/03/2026.
//

import Foundation

final class ChatMemoryStore {
    static let shared = ChatMemoryStore()
    private init() {}

    private let fileName = "chat_memory.json"

    private var fileURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent(fileName)
    }

    func load() -> [ChatMessage] {
        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder.iso8601.decode([ChatMessage].self, from: data)
        } catch {
            return []
        }
    }

    func save(_ messages: [ChatMessage]) {
        do {
            let data = try JSONEncoder.iso8601.encode(messages)
            try data.write(to: fileURL, options: [.atomic])
        } catch {
            print("ChatMemoryStore save error:", error.localizedDescription)
        }
    }

    func clear() {
        try? FileManager.default.removeItem(at: fileURL)
    }
}

private extension JSONEncoder {
    static var iso8601: JSONEncoder {
        let enc = JSONEncoder()
        enc.dateEncodingStrategy = .iso8601
        enc.outputFormatting = [.prettyPrinted]
        return enc
    }
}

private extension JSONDecoder {
    static var iso8601: JSONDecoder {
        let dec = JSONDecoder()
        dec.dateDecodingStrategy = .iso8601
        return dec
    }
}
