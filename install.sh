#!/bin/bash
# Setup dbi-install: dependensi + perintah global di ~/.local/bin
set -eu

DIR="$(cd "$(dirname "$0")" && pwd)"
VENV="$HOME/.venvs/dbi"
BACKEND="$HOME/Downloads/dbibackend"
PYSYS="${DBI_PYSYS:-/opt/homebrew/bin/python3}"
BIN="$HOME/.local/bin"

command -v brew >/dev/null || { echo "Homebrew wajib dipasang dulu: https://brew.sh" >&2; exit 1; }

echo "== 1/4 dependensi"
brew list --versions libusb >/dev/null 2>&1 || brew install libusb
"$PYSYS" -c "import tkinter" >/dev/null 2>&1 || brew install python-tk

echo "== 2/4 venv + pyusb ($VENV)"
[ -x "$VENV/bin/python" ] || "$PYSYS" -m venv "$VENV"
"$VENV/bin/python" -c "import usb" >/dev/null 2>&1 || "$VENV/bin/python" -m pip install --quiet --upgrade pip pyusb

echo "== 3/4 dbibackend ($BACKEND)"
[ -s "$BACKEND" ] || curl -sL https://raw.githubusercontent.com/rashevskyv/dbi/main/dbibackend -o "$BACKEND"
chmod +x "$BACKEND"

echo "== 4/4 perintah global ($BIN/dbi-install)"
mkdir -p "$BIN"
chmod +x "$DIR/dbi-install.sh"
ln -sf "$DIR/dbi-install.sh" "$BIN/dbi-install"

case ":$PATH:" in
  *":$BIN:"*) ;;
  *) grep -qs 'local/bin' "$HOME/.zshrc" 2>/dev/null || {
       printf '\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$HOME/.zshrc"
       echo "PATH ditambahkan ke ~/.zshrc (buka terminal baru)"
     } ;;
esac

echo
echo "Selesai. Coba: dbi-install --help 2>/dev/null || dbi-install"
