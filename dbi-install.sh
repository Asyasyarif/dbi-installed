#!/bin/bash
# dbi-install — send NSP/NSZ/XCI/XCZ files to a Nintendo Switch over USB (DBIbackend method).
#
#   dbi-install                   send every .nsp/.xci in the current folder
#   dbi-install ~/Games/Mario     send everything in that folder
#   dbi-install a.nsp b.nsp       send specific files
#
# Before running: on the Switch, open DBI > "Install title from DBIbackend" (Y button),
# then plug in the USB-C cable.

set -u

PY="${DBI_PYTHON:-$HOME/.venvs/dbi/bin/python}"
BACKEND="${DBI_BACKEND:-$HOME/Downloads/dbibackend}"

[ -x "$PY" ] || { echo "venv not found: $PY  -> run ./install.sh" >&2; exit 1; }
[ -f "$BACKEND" ] || { echo "dbibackend not found: $BACKEND  -> run ./install.sh" >&2; exit 1; }

# No arguments = current folder. For double-click use dbi-install.command,
# which passes the folder it sits in to this script.
shopt -s nullglob nocaseglob
targets=()
if [ "$#" -gt 0 ]; then
  for a in "$@"; do
    if [ -d "$a" ]; then
      for f in "$a"/*.nsp "$a"/*.nsz "$a"/*.xci "$a"/*.xcz; do targets+=("$f"); done
    elif [ -f "$a" ]; then
      targets+=("$a")
    else
      echo "skipped (not found): $a" >&2
    fi
  done
else
  for f in *.nsp *.nsz *.xci *.xcz; do targets+=("$f"); done
fi

if [ "${#targets[@]}" -eq 0 ]; then
  echo "No .nsp/.nsz/.xci/.xcz files in: ${*:-$(pwd)}" >&2
  exit 1
fi

pgrep -q OpenMTP && echo "OpenMTP is running - close it first, it fights over the same USB device." >&2
pgrep -qf "dbibackend" && echo "Another dbibackend server is running - stop it first: pkill -f dbibackend" >&2

echo "Folder : $(pwd)"
echo "Sending: ${#targets[@]} file(s)"
printf '  - %s\n' "${targets[@]##*/}"
echo "Switch : DBI > Install title from DBIbackend (Y button)"

exec "$PY" "$BACKEND" "${targets[@]}"
