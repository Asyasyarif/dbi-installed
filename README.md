# dbi-installed

Send game files (`.nsp` / `.nsz` / `.xci` / `.xcz`) from a Mac to a Nintendo Switch over a USB cable
using the **DBIbackend** method. DBI reads the package directly, so large files (>4 GB) are never
written to the FAT32 SD card and never need to be split.

## Why not MTP?

MTP (OpenMTP / Android File Transfer) tends to drop the connection on recent macOS versions, and
copying the file to the SD card still hits the 4 GB FAT32 limit. This method uses DBI's own protocol:
the data streams straight into the installer, and the game is installed to SD or NAND depending on
what you pick on the Switch.

## Install

```bash
git clone https://github.com/Asyasyarif/dbi-installed.git
cd dbi-installed
./install.sh
```

`install.sh` sets up everything: `libusb`, `python-tk`, the `~/.venvs/dbi` venv with `pyusb`,
the `dbibackend` script, and the global commands `dbii` (short) and `dbi-install` in `~/.local/bin`.

## Usage

1. On the Switch: **DBI → Install title from DBIbackend** (**Y** button)
2. Plug the USB-C cable into the Mac
3. On the Mac:

```bash
dbii                             # every .nsp in the current folder (recursive)
dbii ~/Games/MarioKart           # everything inside a folder (recursive)
dbii game.nsp update.nsp         # specific files
```

`dbi-install` works exactly the same if you prefer the long name.

Folders are scanned recursively, so a folder full of game folders works in one shot.

4. On the Switch: press **X** to select packages → **A** → choose **Install target** (SD / NAND) →
   **Start install**

### From Finder (double-click)

Copy `dbi-install.command` into a folder of NSP files and double-click it — it sends everything in
that folder:

```bash
cp dbi-install.command "/path/to/game-folder/"
```

## Notes

- Close **OpenMTP** before running; both use the same USB device.
- Do not unplug the cable while a transfer is running.
- Override locations if needed: `DBI_PYTHON=... DBI_BACKEND=... dbii`
- `dbibackend` © [rashevskyv/dbi](https://github.com/rashevskyv/dbi) (downloaded automatically by `install.sh`).
