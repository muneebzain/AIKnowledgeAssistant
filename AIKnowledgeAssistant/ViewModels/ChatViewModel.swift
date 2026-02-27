//
//  ChatViewModel.swift
//  AIKnowledgeAssistant
//
//  Created by Muneeb Zain on 28/02/2026.
//

import Foundation
import Combine

@MainActor
class ChatViewModel: ObservableObject {
    
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isLoading: Bool = false
    
    func send() {
        guard !inputText.isEmpty else { return }
        
        let userMessage = ChatMessage(text: inputText, isUser: true)
        messages.append(userMessage)
        
        let question = inputText
        inputText = ""
        
        let aiMessage = ChatMessage(text: "", isUser: false)
        messages.append(aiMessage)
        
        isLoading = true
        
        AIService.shared.streamAnswer(question: question) { token in
            
            if let index = self.messages.lastIndex(where: { !$0.isUser }) {
                self.messages[index].text += token
            }
        }
    }
}
