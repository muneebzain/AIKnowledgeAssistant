# AIKnowledge Assistant (iOS)

## Overview

AIKnowledge Assistant is a SwiftUI-based iOS application that connects to a custom Retrieval-Augmented Generation (RAG) backend to deliver grounded, real-time AI responses based on uploaded documents.

This is not a generic chat application that simply forwards prompts to a language model. It demonstrates a production-style AI system where relevant document context is retrieved first, and only then used to generate answers. This significantly reduces hallucinations and improves reliability.

The app supports live streaming responses, local chat memory, PDF ingestion, and global document search across all uploaded files.

---

## What the App Does

When a user asks a question:

1. The question is sent to a FastAPI RAG backend.  
2. The backend retrieves relevant document chunks using vector search and hybrid ranking.  
3. A local LLM (running via Ollama) generates a grounded response using only the retrieved context.  
4. The response streams back token by token.  
5. The UI updates progressively in real time.  
6. The conversation is stored locally for persistence.  

Users can upload PDF documents, which are processed by the backend and instantly become part of the searchable knowledge base.

---

## Real-World Use Cases

This architecture can power:

- Company internal knowledge assistants  
- Technical documentation search tools  
- Legal or contract analysis systems  
- Educational AI tutors  
- Enterprise AI copilots  

The system is designed to be scalable and production-ready.

---

## Key Features

- Built entirely in SwiftUI  
- Real-time streaming using URLSessionDataDelegate  
- Local persistent chat memory (JSON-based storage)  
- "New Chat" reset functionality  
- PDF upload and ingestion support  
- Clean MVVM architecture  
- Modular networking layer  
- Global document search across all uploaded files  
- Streaming UI with automatic scroll handling  

---

## Architecture

User Input  
→ ChatViewModel  
→ AIService (Networking Layer)  
→ FastAPI RAG Backend  
→ Vector Retrieval + Hybrid Ranking  
→ Context Limiting  
→ Local LLM (Ollama)  
→ Streaming Tokens  
→ Progressive UI Update  
→ Local Message Persistence  

Streaming ensures that responses appear naturally as they are generated, instead of waiting for the full answer to complete.

---

## Technology Stack

- Swift  
- SwiftUI  
- URLSession (Streaming Implementation)  
- MVVM Architecture  
- JSON Local Storage  
- FastAPI Backend  
- ChromaDB (Vector Database)  
- Ollama (Local LLM Runtime)  

---

## Running the App

### Step 1 — Run the Backend

You must first run the backend from the GitHub repository:

```bash
git clone https://github.com/your-username/ai-rag-backend.git
cd ai-rag-backend
pip install -r requirements.txt
uvicorn main:app --reload
````

Make sure Ollama is installed and running locally with the configured model.

---

### Step 2 — Run the iOS App

1. Open the iOS project in Xcode.
2. If testing on a physical device, replace `127.0.0.1` with your Mac’s local IP address.
3. Build and run.
4. Upload PDF documents.
5. Start asking questions.

---

## Purpose

This project was built to demonstrate:

* End-to-end Retrieval-Augmented Generation architecture
* Hybrid search with vector similarity and keyword scoring
* Context-aware LLM prompting
* Real-time streaming AI responses
* Mobile and backend AI integration
* Production-style reliability patterns

It represents applied AI engineering rather than simple prompt-based chat integration.

