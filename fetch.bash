#!/usr/bin/env bash

set -e

EXPORT_DIR="vscode-backup"

echo "Creating export folder..."
mkdir -p "$EXPORT_DIR/extensions"
mkdir -p "$EXPORT_DIR/user"

echo "Exporting extension list..."
code --list-extensions > "$EXPORT_DIR/extensions/extensions.txt"

echo "Downloading VSIX packages..."

while read -r extension; do
    echo "Downloading $extension"

    url="https://marketplace.visualstudio.com/_apis/public/gallery/publishers/${extension%.*}/vsextensions/${extension#*.}/latest/vspackage"

    curl -L "$url" -o "$EXPORT_DIR/extensions/$extension.vsix"

done < "$EXPORT_DIR/extensions/extensions.txt"

echo "Copying settings..."

VSCODE_USER="$HOME/.config/Code/User"

cp "$VSCODE_USER/settings.json" "$EXPORT_DIR/user/" 2>/dev/null || true
cp "$VSCODE_USER/keybindings.json" "$EXPORT_DIR/user/" 2>/dev/null || true

if [ -d "$VSCODE_USER/snippets" ]; then
    cp -r "$VSCODE_USER/snippets" "$EXPORT_DIR/user/"
fi

echo "Backup complete!"
echo "Folder created: $EXPORT_DIR"
