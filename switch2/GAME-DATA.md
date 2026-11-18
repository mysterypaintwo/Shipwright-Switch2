# Make the game data for Ship of Harkinian (Switch 2)

The Switch 2 build needs `oot.otr` (or `oot-mq.otr` for Master Quest), made
from your own Ocarina of Time ROM. This file holds the game's data, so it is
not in the download: you make it once, on a computer, with the PC version of
Ship of Harkinian.

**Use the PC version 8.0.6 ("MacReady Golf").** The Switch 2 build is version
8.0.6, and it refuses an `oot.otr` from another major version. The newest PC
release (9.x) makes `oot.o2r`, which this build cannot read.

## What you need

- A computer with Windows, macOS or Linux.
- An Ocarina of Time ROM that you dumped yourself, in one of these versions:

  | ROM | SHA-1 |
  |---|---|
  | PAL 1.0 | `328a1f1beba30ce5e178f031662019eb32c5f3b5` |
  | PAL 1.1 | `cfbb98d392e4a9d39da8285d10cbef3974c2f012` |
  | PAL GameCube | `0227d7c0074f2d0ac935631990da8ec5914597b4` |
  | PAL Master Quest (GameCube) | `f46239439f59a2a594ef83cf68ef65043b1bffe2` |

  US (NTSC) ROMs are not supported by version 8.0.6. To check a ROM, compare
  its SHA-1 with the table (for example `certutil -hashfile rom.z64 SHA1` on
  Windows, `shasum rom.z64` on macOS and Linux).

## Steps

1. Download the PC version 8.0.6 for your computer from
   <https://github.com/HarbourMasters/Shipwright/releases/tag/8.0.6>:
   - Windows: `SoH-MacReady-Golf-Win64.zip`
   - macOS: `SoH-MacReady-Golf-Mac.zip`
   - Linux: `SoH-MacReady-Golf-Linux-Performance.zip`
2. Unzip it and start Ship of Harkinian.
3. When it asks for a ROM, choose your ROM file. It makes the game data. This
   takes a few minutes. Then the game starts: you can close it.
4. Find the new file:
   - `oot.otr` from a normal ROM, `oot-mq.otr` from a Master Quest ROM.
   - Windows: in the folder of the program.
   - macOS: in `~/Library/Application Support/soh/` (in Finder: Go > Go to
     Folder).
   - Linux: in the folder of the program, or in `~/.local/share/soh/`.

   If it is not there, search your computer for `oot.otr`.
5. Copy `oot.otr` and/or `oot-mq.otr` to `/switch/soh/` on the Switch 2's SD
   card, next to `soh.nro` and `soh.otr`.

To have both quests, make both files (one from each ROM) and copy both: you
then pick the quest when you make a new save file.

## If it does not start

- "OTR version does not match": the file was made by another version of Ship
  of Harkinian. Make it again with 8.0.6.
- Nothing happens or the game closes: send `/switch/soh/logs/` from the SD
  card with your report. After a crash, the folder also has a
  `crash-<date>.txt` file.
