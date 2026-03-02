# AIKnowledge Assistant (iOS)

## Overview

AIKnowledge Assistant is a SwiftUI-based iOS application that connects
to a custom Retrieval-Augmented Generation (RAG) backend to provide
grounded, real-time AI responses based on uploaded documents.

This is not a generic chat application. It demonstrates a
production-style AI system that retrieves relevant context before
generating answers, reducing hallucinations and improving reliability.

The app streams responses live, maintains chat memory locally, and
supports document ingestion for global knowledge search.

------------------------------------------------------------------------

## What the App Does

When a user asks a question:

1.  The question is sent to a FastAPI RAG backend.
2.  The backend retrieves relevant document chunks using vector and
    hybrid search.
3.  A local LLM (via Ollama) generates a grounded response using only
    the retrieved context.
4.  The answer streams back token by token.
5.  The UI updates progressively in real time.
6.  The conversation is saved locally for persistence.

Users can upload PDF documents, which are ingested into the backend and
become searchable instantly.

------------------------------------------------------------------------

## Key Features

-   Built entirely in SwiftUI
-   Real-time streaming using
-   Local persistent chat memory (JSON-based storage)
-   "New Chat" reset functionality
-   PDF upload and ingestion support
-   Clean MVVM architecture
-   Modular networking layer
-   Global document search across all uploaded files

------------------------------------------------------------------------

## Architecture

User Input
→ ChatViewModel
→ AIService (Networking Layer)
→ FastAPI RAG Backend
→ Vector Retrieval + Hybrid Ranking
→ Local LLM (Ollama)
→ Streaming Tokens
→ Progressive UI Update
→ Local Message Persistence

Streaming ensures the UI updates as tokens arrive instead of waiting for
a full response.

------------------------------------------------------------------------

## Technology Stack

-   Swift
-   SwiftUI
-   URLSession (streaming implementation)
-   MVVM Architecture
-   JSON Local Storage
-   FastAPI Backend
-   Ollama (Local LLM)

------------------------------------------------------------------------

## Running the App

1.  Make sure the backend server is running.
2.  Replace `127.0.0.1` with your Mac's local IP address if testing on a
    physical device.
3.  Open the project in Xcode.
4.  Build and run.
5.  Upload PDFs and start asking questions.

------------------------------------------------------------------------

## Purpose

This app was built to demonstrate:

-   End-to-end RAG architecture
-   Real-time AI streaming
-   Grounded answer generation
-   Mobile and backend AI integration
-   Production-style AI reliability patterns

It reflects applied AI engineering rather than simple prompt-based chat
integration.
