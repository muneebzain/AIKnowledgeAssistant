//
//  ChatView.swift
//  AIKnowledgeAssistant
//
//  Created by Muneeb Zain on 28/02/2026.
//

import SwiftUI

struct ChatView: View {
    
    @StateObject private var vm = ChatViewModel()
    
    var body: some View {
        VStack {
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(vm.messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                        
                        if vm.isLoading {
                            ProgressView()
                        }
                    }
                    .padding()
                }
                .onChange(of: vm.messages.count) { _ in
                    if let last = vm.messages.last {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }
            
            HStack {
                TextField("Ask something...", text: $vm.inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Send") {
                    vm.send()
                }
            }
            .padding()
        }
    }
}
