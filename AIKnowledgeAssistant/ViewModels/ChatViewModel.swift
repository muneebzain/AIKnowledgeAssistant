//
//  ChatViewModel.swift
//  AIKnowledgeAssistant
//
//  Created by Muneeb Zain on 28/02/2026.
//


import Foundation
import Combine

@MainActor
final class ChatViewModel: ObservableObject {

    @Published var messages: [ChatMessage] = []
    @Published var input: String = ""

    private var pendingSaveTask: Task<Void, Never>?

    init() {
        // Load chat memory on start
        self.messages = ChatMemoryStore.shared.load()
    }

    func newChat() {
        messages.removeAll()
        ChatMemoryStore.shared.clear()
    }

    func send() {
        let question = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !question.isEmpty else { return }
        input = ""

        // 1) User message
        messages.append(ChatMessage(isUser: true, text: question))
        persistNow()

        // 2) Assistant placeholder (streaming)
        let assistantId = UUID()
        messages.append(ChatMessage(id: assistantId, isUser: false, text: "", isStreaming: true))
        persistNow()

        AIService.shared.streamAnswer(
            question: question,
            onToken: { [weak self] token in
                guard let self else { return }
                // Find assistant message by ID (safe even if array changes)
                guard let idx = self.messages.firstIndex(where: { $0.id == assistantId }) else { return }
                self.messages[idx].text += token
                self.persistThrottled()
            },
            onComplete: { [weak self] in
                guard let self else { return }
                guard let idx = self.messages.firstIndex(where: { $0.id == assistantId }) else { return }
                self.messages[idx].isStreaming = false
                self.persistNow()
            },
            onError: { [weak self] error in
                guard let self else { return }
                guard let idx = self.messages.firstIndex(where: { $0.id == assistantId }) else { return }
                self.messages[idx].isStreaming = false
                self.messages[idx].text = "Error: \(error.localizedDescription)"
                self.persistNow()
            }
        )
    }

    private func persistNow() {
        pendingSaveTask?.cancel()
        ChatMemoryStore.shared.save(messages)
    }

    private func persistThrottled(delaySeconds: Double = 0.35) {
        pendingSaveTask?.cancel()
        pendingSaveTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: UInt64(delaySeconds * 1_000_000_000))
            guard let self else { return }
            ChatMemoryStore.shared.save(self.messages)
        }
    }
}
