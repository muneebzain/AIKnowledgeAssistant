//
//  MessageBubble.swift
//  AIKnowledgeAssistant
//
//  Created by Muneeb Zain on 28/02/2026.
//

import SwiftUI

struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack(alignment: .bottom) {
            if message.isUser { Spacer(minLength: 40) }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 6) {
                HStack(spacing: 8) {
                    if !message.isUser {
                        Circle()
                            .frame(width: 26, height: 26)
                            .overlay(Text("AI").font(.caption).bold())
                    }
                    
                    Text(message.text.isEmpty && message.isStreaming ? "..." : message.text)
                        .font(.system(size: 15))
                        .foregroundStyle(message.isUser ? .white : .primary)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .background(message.isUser ? Color.blue : Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(message.isUser ? Color.clear : Color(.separator), lineWidth: 0.5)
                        )
                    
                    if message.isUser {
                        Circle()
                            .frame(width: 26, height: 26)
                            .overlay(Text("Me").font(.caption).bold())
                    }
                }
                
                if message.isStreaming && !message.isUser {
                    HStack(spacing: 6) {
                        ProgressView()
                            .scaleEffect(0.85)
                        Text("Generating...")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.leading, 34)
                }
            }
            
            if !message.isUser { Spacer(minLength: 40) }
        }
    }
}
