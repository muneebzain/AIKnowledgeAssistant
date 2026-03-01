# AIKnowledgeAssistant

AIKnowledgeAssistant is a SwiftUI-based iOS app that connects to a custom Retrieval-Augmented Generation (RAG) backend to deliver grounded, real-time AI responses.

I built this project to demonstrate how a real AI system works end to end — not just how to send prompts to a language model, but how to design retrieval, safety checks, streaming, and persistence in a production-style architecture.

---

## What This App Does

When a user asks a question:

1. The app sends the request to a FastAPI RAG backend.
2. The backend retrieves relevant information from indexed documents.
3. A local LLM (running via Ollama) generates an answer using only that retrieved context.
4. The response streams back token by token.
5. The UI updates live as the answer is generated.
6. The conversation is automatically saved on the device.

Instead of waiting for a full response, the answer appears progressively, creating a natural and responsive experience.

When the app is reopened, the previous conversation is restored automatically.

---

## Persistent Chat Memory

The app now includes built-in conversation memory.

Messages are saved locally using JSON storage. Streaming responses are persisted safely without affecting performance, and the entire chat is restored when the app launches again.

There is also a “New Chat” option that clears the conversation and resets the session.

This turns the app from a simple demo into a proper conversational interface.

---

## Why This Project Is Different

Many AI apps simply forward a prompt to a language model and display whatever comes back.

This project takes a more structured approach:

* It retrieves relevant knowledge before generating an answer.
* It calculates confidence based on similarity scores.
* It can refuse low-confidence responses.
* It checks grounding to reduce hallucination risk.
* It streams responses in real time.
* It maintains conversation state locally.

The goal was to build something that reflects real AI system design rather than just API integration.

---

## Features

* Built entirely with SwiftUI
* Real-time streaming using URLSessionDataDelegate
* Persistent chat memory
* Clean networking architecture
* Retrieval-Augmented Generation backend
* Confidence-based response handling
* Refusal logic for unreliable answers
* Modular structure for scalability

---

## Architecture Overview

User Input
→ ChatViewModel
→ AIService (network layer)
→ FastAPI RAG backend
→ Vector retrieval + context building
→ Local LLM (Ollama)
→ Streaming response
→ SwiftUI updates
→ Local message persistence

Streaming allows the UI to update as tokens arrive instead of waiting for the full response.

---

## Technology Stack

* Swift
* SwiftUI
* URLSession (streaming implementation)
* FastAPI
* ChromaDB (vector storage)
* Ollama (local LLM)
* Local JSON persistence

---

## Real-World Use Cases

This architecture can be adapted for:

* Internal company knowledge assistants
* Enterprise document search
* AI copilots inside SaaS tools
* Customer support systems
* Educational assistants

The backend and mobile integration are designed with production-style patterns in mind.

---

## Running the App

1. Make sure the FastAPI backend is running.
2. If using a physical device, replace `127.0.0.1` with your Mac’s local IP address.
3. Open the project in Xcode.
4. Build and run.
5. Ask a question and watch the response stream live.

You can close and reopen the app to see that the conversation persists.


