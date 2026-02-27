//
//  AIService.swift
//  AIKnowledgeAssistant
//
//  Created by Muneeb Zain on 28/02/2026.
//

import Foundation

class AIService: NSObject, URLSessionDataDelegate {
    
    static let shared = AIService()
    
    private let baseURL = "http://127.0.0.1:8000"
    
    private var onTokenReceived: ((String) -> Void)?
    
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    func streamAnswer(
        question: String,
        onToken: @escaping (String) -> Void
    ) {
        
        guard let url = URL(string: "\(baseURL)/ask-stream") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "question": question,
            "top_k": 3
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        self.onTokenReceived = onToken
        
        let task = session.dataTask(with: request)
        task.resume()
    }
    
    // MARK: - Streaming Delegate
    
    func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive data: Data
    ) {
        if let chunk = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async {
                self.onTokenReceived?(chunk)
            }
        }
    }
}
