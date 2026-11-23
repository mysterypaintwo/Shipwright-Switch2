# Make the game data (oot.o2r)

The game data is not included. You make `oot.o2r` (or `oot-mq.o2r` for Master
Quest) once from your own ROM, using the PC version 9.3.1. Other versions make
data that this build refuses.

## You need

- A Windows, macOS or Linux computer.
- Your own Ocarina of Time ROM. US, Japanese, PAL, GameCube and Master Quest
  versions are supported. The full list is in
  [supportedHashes.json](https://github.com/mysterypaintwo/Shipwright-Switch2/blob/ounce/docs/supportedHashes.json).

## Steps

1. Download Ship of Harkinian 9.3.1 for your computer from the
   [official release](https://github.com/HarbourMasters/Shipwright/releases/tag/9.3.1):
   - [Windows](https://github.com/HarbourMasters/Shipwright/releases/download/9.3.1/SoH-Dewey-Bravo-Win64.zip)
   - [macOS](https://github.com/HarbourMasters/Shipwright/releases/download/9.3.1/SoH-Dewey-Bravo-Mac.zip)
   - [Linux](https://github.com/HarbourMasters/Shipwright/releases/download/9.3.1/SoH-Dewey-Bravo.appimage)
2. Unzip it if needed, and start Ship of Harkinian.
   - macOS may block it. Try to open it once, then click **Open Anyway** in
     System Settings > Privacy & Security.
3. Choose your ROM when asked. When the game starts, close it.
4. Find `oot.o2r` (`oot-mq.o2r` for a Master Quest ROM):
   - Windows: the program's folder.
   - macOS: `~/Library/Application Support/com.shipofharkinian.soh/`
   - Linux: the program's folder or `~/.local/share/soh/`

   If it is not there, search your computer for `oot.o2r`.
5. Copy it to `/switch/soh/` on your SD card.

To have both quests, make both files and copy both. You then pick the quest
when you make a new save file.

If the game says the archive was made by a different version, make it again
with 9.3.1.
