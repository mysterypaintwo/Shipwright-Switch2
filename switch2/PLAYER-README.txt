SHIP OF HARKINIAN FOR SWITCH 2 - v1.1
=====================================

Unofficial port for a Switch 2 that can run homebrew, based on Ship of
Harkinian 9.3.1.


WHAT'S NEW IN v1.1
- Updated to Ship of Harkinian 9.3.1, with its full-screen menu.
- Gyro and right stick aiming in first person.
- Save state buttons, with save and load mappable in Settings > Controls.
- Less stutter, a loading screen and audio fixes.
- Nintendo button names in the controls menu.
See CHANGELOG.md for the full list.

Updating from v1.0: your old oot.otr no longer works. Make a new oot.o2r by
following GAME-DATA.md, and delete soh.otr and oot.otr. Back up
/switch/soh/Save/ first.


INSTALL
1. Copy the "switch" folder to the root of your SD card, replacing old files.

2. Make oot.o2r (or oot-mq.o2r for Master Quest) from your own ROM by
   following GAME-DATA.md, and copy it to /switch/soh/.

3. Check that /switch/soh/ has:

     soh.nro
     soh.o2r
     oot.o2r and/or oot-mq.o2r

4. Start "HarbourMasters - Shipwright" from the homebrew menu.
   The first launch takes longer while it prepares shaders.


CONTROLS
  Switch 2 button     Game button
  B                   A
  Y                   B
  A                   C-Down
  X                   C-Left
  R                   C-Right
  ZL                  Z
  ZR                  R
  Right stick         C buttons
  -                   Open the menu

Aiming: Enhancements > Quality of Life > Controls.
Save states: turn them on in the Cheats menu.


REPORTING A BUG
Say what you were doing, and include the /switch/soh/logs/ folder.
Do not share your ROM, oot.o2r or oot-mq.o2r.


This project is not affiliated with or endorsed by Nintendo.
