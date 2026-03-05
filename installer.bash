#!/usr/bin/env bash

echo "Installing extensions..."

for file in extensions/*.vsix; do
    code --install-extension "$file"
done

echo "Copying settings..."

VSCODE_USER="$HOME/.config/Code/User"

mkdir -p "$VSCODE_USER"

cp user/settings.json "$VSCODE_USER/" 2>/dev/null || true
cp user/keybindings.json "$VSCODE_USER/" 2>/dev/null || true

if [ -d user/snippets ]; then
    cp -r user/snippets "$VSCODE_USER/"
fi

echo "VS Code setup restored!"
