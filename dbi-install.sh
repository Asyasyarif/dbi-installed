#!/bin/bash
# dbi-install — kirim NSP/NSZ/XCI/XCZ ke Switch lewat kabel USB (metode DBIbackend).
#
#   dbi-install                   kirim semua .nsp di folder sekarang
#   dbi-install ~/Games/Mario     kirim isi folder itu
#   dbi-install a.nsp b.nsp       kirim file tertentu
#
# Sebelum jalan: Switch > DBI > "Install title from DBIbackend" (tombol Y), lalu colok kabel USB.

set -u

PY="${DBI_PYTHON:-$HOME/.venvs/dbi/bin/python}"
BACKEND="${DBI_BACKEND:-$HOME/Downloads/dbibackend}"

[ -x "$PY" ] || { echo "venv tidak ada: $PY  -> jalankan ./install.sh" >&2; exit 1; }
[ -f "$BACKEND" ] || { echo "dbibackend tidak ada: $BACKEND  -> jalankan ./install.sh" >&2; exit 1; }

# Tanpa argumen = folder sekarang. Untuk double-click pakai dbi-install.command
# (dia yang mengirim folder tempatnya berada ke script ini).
shopt -s nullglob nocaseglob
targets=()
if [ "$#" -gt 0 ]; then
  for a in "$@"; do
    if [ -d "$a" ]; then
      for f in "$a"/*.nsp "$a"/*.nsz "$a"/*.xci "$a"/*.xcz; do targets+=("$f"); done
    elif [ -f "$a" ]; then
      targets+=("$a")
    else
      echo "dilewati (tidak ada): $a" >&2
    fi
  done
else
  for f in *.nsp *.nsz *.xci *.xcz; do targets+=("$f"); done
fi

if [ "${#targets[@]}" -eq 0 ]; then
  echo "Tidak ada file .nsp/.nsz/.xci/.xcz di: ${*:-$(pwd)}" >&2
  exit 1
fi

pgrep -q OpenMTP && echo "OpenMTP sedang jalan — tutup dulu, nanti rebutan device USB." >&2
pgrep -qf "dbibackend" && echo "Server dbibackend lain sedang jalan — matikan dulu: pkill -f dbibackend" >&2

echo "Folder : $(pwd)"
echo "Kirim  : ${#targets[@]} file"
printf '  - %s\n' "${targets[@]##*/}"
echo "Switch : DBI > Install title from DBIbackend (tombol Y)"

exec "$PY" "$BACKEND" "${targets[@]}"
