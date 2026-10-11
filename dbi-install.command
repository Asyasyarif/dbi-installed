#!/bin/bash
# Taruh file ini di folder yang isinya NSP, lalu double-click untuk kirim ke Switch.
exec "$HOME/.local/bin/dbi-install" "$(dirname "$0")"
