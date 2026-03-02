AIKnowledge Assistant (iOS)
Overview

AIKnowledge Assistant is a SwiftUI-based iOS application that connects to a custom Retrieval-Augmented Generation (RAG) backend to provide grounded, real-time AI responses based on uploaded documents.

This is not a generic chat app. It is built to demonstrate a production-style AI system that retrieves relevant context before generating answers, reducing hallucinations and improving reliability.

The app streams responses live, maintains chat memory locally, and supports document ingestion for global knowledge search.

What the App Does

When a user asks a question:

The question is sent to a FastAPI RAG backend.

The backend retrieves relevant document chunks using vector + hybrid search.

A local LLM (via Ollama) generates a grounded response.

The answer streams back token by token.

The UI updates progressively in real time.

The conversation is saved locally for persistence.

Users can upload PDF documents, which are ingested into the backend and become searchable instantly.

Key Features

Built entirely in SwiftUI

Real-time streaming using URLSessionDataDelegate

Local persistent chat memory (JSON-based storage)

“New Chat” reset functionality

PDF upload and ingestion support

Clean MVVM architecture

Modular networking layer

Global document search across all uploaded files

Architecture

User Input
→ ChatViewModel
→ AIService (Networking Layer)
→ FastAPI RAG Backend
→ Vector Retrieval + Hybrid Ranking
→ Local LLM (Ollama)
→ Streaming Tokens
→ Progressive UI Update
→ Local Message Persistence

Streaming ensures the UI updates as tokens arrive instead of waiting for a full response.

Technology Stack

Swift

SwiftUI

URLSession (streaming implementation)

MVVM Architecture

JSON Local Storage

FastAPI Backend

Ollama (Local LLM)

Running the App

Make sure the backend server is running.

Replace 127.0.0.1 with your Mac’s local IP if testing on a physical device.

Open the project in Xcode.

Build and run.

Upload PDFs and start asking questions.

Purpose

This app was built to demonstrate:

End-to-end RAG architecture

Real-time AI streaming

Grounded answer generation

Mobile + backend AI integration

Production-style AI reliability patterns

It reflects applied AI engineering rather than simple prompt-based chat.
