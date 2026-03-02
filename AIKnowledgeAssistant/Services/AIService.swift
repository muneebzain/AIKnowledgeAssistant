//
//  AIService.swift
//  AIKnowledgeAssistant
//
//  Created by Muneeb Zain on 28/02/2026.
//

import Foundation

final class AIService {

    static let shared = AIService()
    private init() {}

    private let baseURL = "http://127.0.0.1:8000"

    // MARK: - Streaming Answer
    func streamAnswer(
        question: String,
        onToken: @escaping (String) -> Void,
        onComplete: @escaping () -> Void,
        onError: @escaping (Error) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)/ask-stream") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["question": question]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        Task {
            do {
                let (bytes, response) = try await URLSession.shared.bytes(for: request)
                guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                    throw NSError(domain: "AIService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                }

                for try await line in bytes.lines {
                    if line.isEmpty { continue }
                    onToken(line)
                }

                onComplete()
            } catch {
                onError(error)
            }
        }
    }

    // MARK: - Ingest Document
    func ingestDocument(
        docId: String,
        text: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)/ingest") else { return }

        let payload: [String: Any] = [
            "doc_id": docId,
            "text": text
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                    completion(.failure(NSError(
                        domain: "AIService",
                        code: 0,
                        userInfo: [NSLocalizedDescriptionKey: "Ingest failed. Server returned an error."]
                    )))
                    return
                }

                completion(.success(()))
            }
        }
        task.resume()
    }
}
