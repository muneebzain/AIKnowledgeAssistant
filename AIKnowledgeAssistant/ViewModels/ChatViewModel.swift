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

    // Upload UI state
    @Published var isUploadingDoc: Bool = false
    @Published var uploadStatusText: String = ""

    private var pendingSaveTask: Task<Void, Never>?

    init() {
        // Load chat memory on launch
        self.messages = ChatMemoryStore.shared.load()
    }

    // MARK: - New Chat
    func newChat() {
        messages.removeAll()
        input = ""
        uploadStatusText = ""
        ChatMemoryStore.shared.clear()
    }

    // MARK: - Send Message
    func sendMessage() {
        let question = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !question.isEmpty else { return }

        DispatchQueue.main.async { [weak self] in
            self?.input = ""
        }

        // User message
        messages.append(ChatMessage(role: .user, text: question))
        persistNow()

        // Assistant placeholder
        let assistantId = UUID()
        messages.append(ChatMessage(id: assistantId, role: .assistant, text: "", isStreaming: true))
        persistNow()

        AIService.shared.streamAnswer(
            question: question,
            onToken: { [weak self] token in
                guard let self else { return }
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

    // MARK: - PDF Ingest
    func ingestPDF(from url: URL) {
        isUploadingDoc = true
        uploadStatusText = "Reading PDF..."

        DispatchQueue.global(qos: .userInitiated).async {
            guard let extractedText = PDFService.extractText(from: url) else {
                DispatchQueue.main.async {
                    self.isUploadingDoc = false
                    self.uploadStatusText = "Could not read text from PDF."
                }
                return
            }

            DispatchQueue.main.async {
                self.uploadStatusText = "Uploading document..."
            }

            let docId = UUID().uuidString

            AIService.shared.ingestDocument(docId: docId, text: extractedText) { result in
                switch result {
                case .success:
                    self.isUploadingDoc = false
                    self.uploadStatusText = "Document uploaded successfully."

                    self.messages.append(ChatMessage(
                        role: .system,
                        text: "Document uploaded. You can now ask questions about it."
                    ))
                    self.persistNow()

                case .failure(let error):
                    self.isUploadingDoc = false
                    self.uploadStatusText = "Upload failed: \(error.localizedDescription)"
                }
            }
        }
    }

    // MARK: - Persistence
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
