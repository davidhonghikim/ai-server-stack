#!/bin/sh

# This script waits for the Ollama server to be ready, then pulls the specified models.

# --- Configuration ---
# List of models to pull, separated by spaces.
# Add all the models from your list here.
MODELS_TO_PULL="
gpt-oss:20b
mannix/qwq-32b-abilterated:latest
wizardlm-uncensored:latest
qwen3:8b
llama3.1:latest
mistral:latest
deepseek-r1:latest
huihui_ai/skywork-o1-abliterated:8b
mixtral:8x22b
wizardlm2:8x22b
command-r-plus:latest
deepseek-r1:70b
llama3.1:70b
qwen3-coder:latest
qwen3:30b
qwen2.5-coder:32b
gemma3:27b
deepseek-r1:32b
deepseek-coder-v2:latest
nomic-embed-text:latest
"

OLLAMA_HOST="ollama:11434"

# --- Main Script ---
echo "Model puller script started."

# 1. Wait for the Ollama server to be available.
echo "Waiting for Ollama server at $OLLAMA_HOST to be available..."
until curl -s -f -o /dev/null "$OLLAMA_HOST"; do
    echo "Ollama server not yet available, waiting 5 seconds..."
    sleep 5
done
echo "Ollama server is up!"

# 2. Loop through the models and pull each one.
for model in $MODELS_TO_PULL; do
    echo "---"
    echo "Pulling model: $model"
    ollama pull "$model"
    if [ $? -eq 0 ]; then
        echo "Successfully pulled $model"
    else
        echo "Failed to pull $model"
    fi
    echo "---"
done

echo "All specified models have been processed."
