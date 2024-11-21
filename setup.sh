#!/bin/bash
echo "Setting up Git hooks..."

# Copy hooks into .git/hooks
cp .git-hooks/post-checkout .git/hooks/post-checkout
cp .git-hooks/post-merge .git/hooks/post-merge

# Make them executable
chmod +x .git/hooks/post-checkout
chmod +x .git/hooks/post-merge

echo "Git hooks installed successfully."
