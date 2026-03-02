//
//  ChatView.swift
//  AIKnowledgeAssistant
//
//  Created by Muneeb Zain on 28/02/2026.
//

import SwiftUI
import UniformTypeIdentifiers

struct ChatView: View {

    @StateObject private var vm = ChatViewModel()
    @State private var showPDFPicker = false

    var body: some View {
        VStack(spacing: 0) {

            header

            Divider()

            uploadStatusBar

            messagesList

            Divider()

            inputBar
        }
        .fileImporter(
            isPresented: $showPDFPicker,
            allowedContentTypes: [.pdf],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                guard let url = urls.first else { return }
                vm.ingestPDF(from: url)
            case .failure(let error):
                vm.uploadStatusText = "File selection error: \(error.localizedDescription)"
            }
        }
    }

    private var header: some View {
        HStack {
            Text("AIKnowledgeAssistant")
                .font(.headline)

            Spacer()

            Button("Upload PDF") {
                showPDFPicker = true
            }
            .font(.subheadline)

            Button("New Chat") {
                vm.newChat()
            }
            .font(.subheadline)
            .padding(.leading, 8)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .overlay(Divider(), alignment: .bottom)
    }

    private var uploadStatusBar: some View {
        Group {
            if vm.isUploadingDoc {
                HStack(spacing: 10) {
                    ProgressView()
                    Text(vm.uploadStatusText.isEmpty ? "Uploading..." : vm.uploadStatusText)
                        .font(.caption)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            } else if !vm.uploadStatusText.isEmpty {
                HStack {
                    Text(vm.uploadStatusText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
        }
    }

    private var messagesList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(vm.messages) { msg in
                        ChatBubble(message: msg)
                            .id(msg.id)
                    }
                }
                .padding()
            }
            .onChange(of: vm.messages) { _, _ in
                guard let lastId = vm.messages.last?.id else { return }
                withAnimation(.easeOut(duration: 0.2)) {
                    proxy.scrollTo(lastId, anchor: .bottom)
                }
            }
            .onAppear {
                guard let lastId = vm.messages.last?.id else { return }
                proxy.scrollTo(lastId, anchor: .bottom)
            }
        }
    }

    private var inputBar: some View {
        HStack(spacing: 10) {
            TextField("Ask something...", text: $vm.input, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(1...4)

            Button("Send") {
                vm.sendMessage()
            }
        }
        .padding()
    }
}
