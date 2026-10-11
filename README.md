# dbi-installed

Kirim file game (`.nsp` / `.nsz` / `.xci` / `.xcz`) dari Mac ke Nintendo Switch lewat kabel USB,
pakai metode **DBIbackend** — DBI membaca paketnya langsung, jadi file besar (>4 GB) tidak pernah
ditulis ke SD card FAT32 dan tidak perlu di-split.

## Kenapa bukan MTP?

MTP (OpenMTP / Android File Transfer) sering putus di macOS baru dan tetap kena batas 4 GB FAT32
kalau file ditempel ke SD card. Metode ini pakai protokol DBI sendiri: transfer langsung ke installer,
lalu game dipasang ke SD atau NAND sesuai pilihan di layar Switch.

## Instalasi

```bash
git clone https://github.com/Asyasyarif/dbi-installed.git
cd dbi-installed
./install.sh
```

`install.sh` menyiapkan semuanya: `libusb`, `python-tk`, venv `~/.venvs/dbi` + `pyusb`,
script `dbibackend`, dan perintah global `dbi-install` di `~/.local/bin`.

## Pakai

1. Switch: **DBI → Install title from DBIbackend** (tombol **Y**)
2. Colok kabel USB-C ke Mac
3. Di Mac:

```bash
dbi-install                      # semua .nsp di folder sekarang
dbi-install ~/Games/MarioKart    # isi folder tertentu
dbi-install game.nsp update.nsp  # file tertentu
```

4. Di Switch: tekan **X** untuk menandai paket → **A** → pilih **Install target** (SD / NAND) →
   **Start install**

### Dari Finder (double-click)

Copy `dbi-install.command` ke folder berisi NSP, lalu double-click — otomatis kirim semua isi folder itu:

```bash
cp dbi-install.command "/path/folder-game/"
```

## Catatan

- Tutup **OpenMTP** sebelum menjalankan — dua-duanya memakai device USB yang sama.
- Jangan cabut kabel selama transfer.
- Override lokasi kalau perlu: `DBI_PYTHON=... DBI_BACKEND=... dbi-install`
- `dbibackend` © [rashevskyv/dbi](https://github.com/rashevskyv/dbi) (diunduh otomatis oleh `install.sh`).
