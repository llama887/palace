#!/bin/bash

# Check if GitHub CLI is already authenticated
if gh auth status >/dev/null 2>&1; then
  echo "You are already logged in to GitHub CLI. Skipping authentication."
else
  echo "Logging in to GitHub CLI..."
  gh auth login
fi

gh auth status

# Set the Git remote URL
git remote set-url origin https://github.com/llama887/palace.git

uv tool install --force --python python3.12 aider-chat@latest
uv tool update-shell

