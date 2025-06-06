# financial_chat_agent

This project demonstrates why a hybrid chat agent (classifier + LLM) can be more robust or secure than a pure LLM approach. This example uses intent classification for core tasks (like "check balance") ensuring accuracy and control of the LLM actions.

## Prerequisites

### Ollama Installation

1. Install Ollama from [ollama.com](https://ollama.com)
2. Pull and run the llama3.2 model:

```bash
ollama pull llama3.2:latest
ollama run llama3.2:latest
```

The Python API server will connect to Ollama running on localhost:11434 by default.

### Python API Setup

1. Install Python dependencies:
```bash
cd classify_query
pip install -r requirements.txt
```

2. Train the classifier:
```bash
python fine_tune.py
```

This will train the classifier on the financial intents dataset and save the model for use by the API server.
