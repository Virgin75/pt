#!/usr/bin/env bash
set -e

PLUGIN_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/opencode/plugins/pt"
BASE_URL="https://raw.githubusercontent.com/Virgin75/pt/main/opencode-plugin"

mkdir -p "$PLUGIN_DIR"

curl -fsSL "$BASE_URL/index.ts" -o "$PLUGIN_DIR/index.ts"
curl -fsSL "$BASE_URL/package.json" -o "$PLUGIN_DIR/package.json"

echo "pt OpenCode plugin installed to $PLUGIN_DIR"
