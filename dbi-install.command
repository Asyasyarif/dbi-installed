#!/bin/bash
# Put this file in a folder full of NSP files, then double-click it to send them to the Switch.
exec "$HOME/.local/bin/dbi-install" "$(dirname "$0")"
