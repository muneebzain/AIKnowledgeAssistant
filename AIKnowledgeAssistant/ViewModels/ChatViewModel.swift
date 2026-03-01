//
//  ChatViewModel.swift
//  AIKnowledgeAssistant
//
//  Created by Muneeb Zain on 28/02/2026.
//

import Foundation
import Combine

final class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var input: String = ""

    func send() {
        let question = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !question.isEmpty else { return }
        input = ""

        // 1) User message
        messages.append(ChatMessage(isUser: true, text: question))

        // 2) Assistant placeholder (streaming)
        messages.append(ChatMessage(isUser: false, text: "", isStreaming: true))
        let assistantIndex = messages.count - 1

        AIService.shared.streamAnswer(
            question: question,
            onToken: { [weak self] token in
                guard let self else { return }
                self.messages[assistantIndex].text += token
            },
            onComplete: { [weak self] in
                guard let self else { return }
                self.messages[assistantIndex].isStreaming = false   // ✅ remove loader
            },
            onError: { [weak self] error in
                guard let self else { return }
                self.messages[assistantIndex].isStreaming = false
                self.messages[assistantIndex].text = "Error: \(error.localizedDescription)"
            }
        )
    }
}
