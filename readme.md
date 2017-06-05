# Scripts for Cemu

What is this? A collection of scripts for various tasks in relation to Cemu. Why is this? Altough Cemu is already a great emulator, it sometimes crashes, playing on the couch or remotely from the PC can make it burdersome to initiate a restart.

Functionality include:
- Starting Cemu game in full screen mode.
- Detecting Cemu has crashed and restarting it.
- Making a backup of the Cemu saves folder.
- Starting a speedhack application.
- Automatically focus window to Cemu.
- Closing of applications and or script when cemu has been stopped by the user.

## All in one scripts explanation

There are two main scripts in the AllInOne folder, a regular one and a simple one.

Detection of crash is done by detecting that the Windows program WerFault.exe is running. 

### StartCemuSimple.bat

This script does the following:
- Check if Cemu is running, if yes, informs user, does nothing and exits
- Starts Cemu full screen with specified game.
- Checks if Cemu has crashed, every 5 seconds, if yes, restarts it.
- In cae Cemu has been closed, the script is also closed.

Side note, this one can be run as a regular user.

### StartCemu.bat

- Check if Cemu is running, if yes, informs user, does nothing and exits
- Creates a backup of the Cemu save game folder
- Starts Cemu full screen with specified game.
- After a timeout (game has been loaded in Cemu), starts the SuperSpeedHack application.
- Checks that that SuperSpeedHack application has been started properly, focusses window on Cemu.
- Checks if Cemu has crashed, every 5 seconds, if yes, restarts everything from the start.
- In cae Cemu has been closed, the script is also closed.

Side note, for best result, this has to be run as administrator. Otherwise certain applications don't allow themselves to be stopped and remain open.

## Extra, third party and credits.

The script uses and starts several items:
- Cemu [link](http://cemu.info/)
- Super Speedhack [link](https://www.reddit.com/r/cemu/comments/63jqmi/super_speedhack_dynamic_speedhack_for_cemu/)
- sendKeys.bat [link](https://github.com/npocmaka/batch.scripts/blob/master/hybrids/jscript/sendKeys.bat)
- Some code examples taken from stack overflow.