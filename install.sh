#!/bin/bash
# Setup for dbi-install: dependencies + global command in ~/.local/bin
set -eu

DIR="$(cd "$(dirname "$0")" && pwd)"
VENV="$HOME/.venvs/dbi"
BACKEND="$HOME/Downloads/dbibackend"
PYSYS="${DBI_PYSYS:-/opt/homebrew/bin/python3}"
BIN="$HOME/.local/bin"

command -v brew >/dev/null || { echo "Homebrew is required: https://brew.sh" >&2; exit 1; }

echo "== 1/4 dependencies"
brew list --versions libusb >/dev/null 2>&1 || brew install libusb
"$PYSYS" -c "import tkinter" >/dev/null 2>&1 || brew install python-tk

echo "== 2/4 venv + pyusb ($VENV)"
[ -x "$VENV/bin/python" ] || "$PYSYS" -m venv "$VENV"
"$VENV/bin/python" -c "import usb" >/dev/null 2>&1 || "$VENV/bin/python" -m pip install --quiet --upgrade pip pyusb

echo "== 3/4 dbibackend ($BACKEND)"
[ -s "$BACKEND" ] || curl -sL https://raw.githubusercontent.com/rashevskyv/dbi/main/dbibackend -o "$BACKEND"
chmod +x "$BACKEND"

echo "== 4/4 global command ($BIN/dbii)"
mkdir -p "$BIN"
chmod +x "$DIR/dbi-install.sh"
ln -sf "$DIR/dbi-install.sh" "$BIN/dbi-install"
ln -sf "$DIR/dbi-install.sh" "$BIN/dbii"

case ":$PATH:" in
  *":$BIN:"*) ;;
  *) grep -qs 'local/bin' "$HOME/.zshrc" 2>/dev/null || {
       printf '\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$HOME/.zshrc"
       echo "Added ~/.local/bin to PATH in ~/.zshrc (open a new terminal)"
     } ;;
esac

echo
echo "Done. Try: dbii"
