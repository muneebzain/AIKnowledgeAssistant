//
//  AIService.swift
//  AIKnowledgeAssistant
//
//  Created by Muneeb Zain on 28/02/2026.
//

import Foundation

final class AIService: NSObject, URLSessionDataDelegate {

    static let shared = AIService()
    private override init() {}

    private let baseURL = "http://127.0.0.1:8000"

    private var onTokenReceived: ((String) -> Void)?
    private var onCompleted: (() -> Void)?
    private var onError: ((Error) -> Void)?

    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 300
        config.timeoutIntervalForResource = 300
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()

    func streamAnswer(
        question: String,
        topK: Int = 3,
        onToken: @escaping (String) -> Void,
        onComplete: @escaping () -> Void,
        onError: @escaping (Error) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)/ask-stream") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "question": question,
            "top_k": topK
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        self.onTokenReceived = onToken
        self.onCompleted = onComplete
        self.onError = onError

        session.dataTask(with: request).resume()
    }

    // Called multiple times during streaming
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let chunk = String(data: data, encoding: .utf8), !chunk.isEmpty else { return }
        DispatchQueue.main.async {
            self.onTokenReceived?(chunk)
        }
    }

    // Called once when stream ends
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                self.onError?(error)
            } else {
                self.onCompleted?()
            }
        }
    }
}
