#!/usr/bin/env bash
set -e

INSTALL_DIR="/usr/local/bin"
INSTALL_NAME="pt"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE="$SCRIPT_DIR/bin/pt"

if [ ! -f "$SOURCE" ]; then
    echo "Error: $SOURCE not found."
    exit 1
fi

if [ ! -d "$INSTALL_DIR" ]; then
    echo "Error: $INSTALL_DIR does not exist. Create it or run with sudo."
    exit 1
fi

cp "$SOURCE" "$INSTALL_DIR/$INSTALL_NAME"
chmod +x "$INSTALL_DIR/$INSTALL_NAME"

echo "pt installed to $INSTALL_DIR/$INSTALL_NAME"
echo ""
echo "pt is ready! Usage: pt [pytest args]"
echo "Example: pt tests/ -k test_login"
