//
//  MessageBubble.swift
//  AIKnowledgeAssistant
//
//  Created by Muneeb Zain on 28/02/2026.
//

import SwiftUI

struct MessageBubble: View {
    
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            Text(message.text)
                .padding()
                .background(message.isUser ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(message.isUser ? .white : .black)
                .cornerRadius(16)
            
            if !message.isUser { Spacer() }
        }
    }
}
