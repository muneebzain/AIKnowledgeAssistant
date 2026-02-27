# AIKnowledgeAssistant

AIKnowledgeAssistant is a SwiftUI-based iOS application that connects to a custom Retrieval-Augmented Generation (RAG) backend to provide grounded, real-time AI responses.

This project was built to demonstrate how to integrate a production-style AI system into a mobile app — not just connect to a generic language model.

---

## What This App Does

When a user asks a question:

* The app sends the request to a RAG backend.
* The backend retrieves relevant information from indexed documents.
* A local language model generates an answer using only that retrieved context.
* The response streams back token by token.
* The UI updates progressively in real time.

Instead of waiting for a full response, the answer appears naturally as it is generated.

---

## Why This Project Is Different

Many AI apps simply forward prompts to a language model and display whatever it returns.

AIKnowledgeAssistant is different because:

* It retrieves relevant knowledge before generating answers.
* It measures confidence based on similarity scores.
* It can refuse low-confidence responses.
* It validates grounding to reduce hallucinations.
* It streams responses live for better user experience.

This project demonstrates real AI system architecture, not just API usage.

---

## Features

* Built entirely in SwiftUI
* Real-time streaming responses
* Clean networking layer using URLSession
* Progressive UI updates
* Works with a grounded RAG backend
* Confidence-aware response handling
* Modular and scalable structure

---

## Architecture

User Input
→ AIService (Networking Layer)
→ FastAPI RAG Backend
→ Local LLM (Ollama)
→ Streaming Tokens
→ Real-Time UI Updates

Streaming is handled using `URLSessionDataDelegate`, allowing the app to process data as it arrives.

---

## Technology Stack

* Swift
* SwiftUI
* URLSession (streaming implementation)
* FastAPI backend
* Local LLM via Ollama

---

## Real-World Applications

This architecture can be adapted for:

* Company knowledge assistants
* Enterprise document search
* AI copilots inside SaaS platforms
* Internal support tools
* Educational AI tutoring systems

The system is designed to power real products.

---

## Running the App

1. Make sure the backend server is running.
2. If testing on a physical device, replace `127.0.0.1` with your Mac’s local IP address.
3. Open the project in Xcode.
4. Build and run.
5. Ask a question and watch the response stream live.

---

## Why I Built This

AIKnowledgeAssistant was built as part of a full-stack AI engineering portfolio to demonstrate:

* End-to-end AI system design
* Retrieval-Augmented Generation
* Streaming AI responses
* Backend and mobile integration
* Production-style reliability patterns

This project reflects practical AI engineering applied to real-world mobile applications.
