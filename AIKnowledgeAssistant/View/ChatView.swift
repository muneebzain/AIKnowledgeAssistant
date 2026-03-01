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
        VStack(spacing: 0) {
            header

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(vm.messages) { msg in
                            ChatBubble(message: msg)
                                .id(msg.id)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.top, 12)
                    .padding(.bottom, 12)
                }
                // Scroll when messages added
                .onChange(of: vm.messages.count) { _ in
                    scrollToBottom(proxy)
                }
                // Scroll while last message text changes (streaming)
                .onChange(of: vm.messages.last?.text) { _ in
                    scrollToBottom(proxy)
                }
            }

            inputBar
        }
        .background(Color(.systemGroupedBackground))
    }

    private var header: some View {
        HStack {
            Text("AIKnowledgeAssistant")
                .font(.headline)
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .overlay(Divider(), alignment: .bottom)
    }

    private var inputBar: some View {
        HStack(spacing: 10) {
            TextField("Ask something...", text: $vm.input, axis: .vertical)
                .lineLimit(1...4)
                .textFieldStyle(.roundedBorder)

            Button {
                vm.send()
            } label: {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 16, weight: .semibold))
            }
            .disabled(vm.input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .overlay(Divider(), alignment: .top)
    }

    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        guard let last = vm.messages.last else { return }
        DispatchQueue.main.async {
            withAnimation(.easeOut(duration: 0.2)) {
                proxy.scrollTo(last.id, anchor: .bottom)
            }
        }
    }
}
