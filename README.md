# simple-mod-organizer-linux
A K.I.S.S. Mod Organizer 2 Setup for Linux using Steam.

# Requirements

- ProtonTricks
- Zenity

## Download Mod Organizer 2

Download mod Organizer 2 from: https://github.com/Modorganizer2/modorganizer/releases
As of 2023-07-09, you'll want the `Mod.Organizer-2.4.4.7z` file. Extract this archive into a folder of the same name, and move this folder inside of your game's base directory. (`../steamapps/common/GameFolder/Mod.Organizer-2.4.4/`)

## Redirect Steam to launch Mod Organizer 2

In your Steam library, navigate to the game you want to use Mod Organizer 2 with. Right click the game, click "Properties" and enter the following line (modify as needed) into the "Launch Options":

  eval $( echo "%command%" | sed "s/FalloutNVLauncher.exe'.*/Mod.Organizer-2.4.4\/ModOrganizer.exe'/")

Note that this line is specifically structured to trick steam into launching ModOrganizer.exe instead of your game's exe. In this case, I am 'replacing' "FalloutNVLauncher.exe" (located in the game's base directory) with "/Mod.Organizer-2.4.4\/ModOrganizer.exe" (located inside the "Mod.Organizer-2.4.4" folder that is inside of the base game's directory). Be sure to replace "FalloutNVLauncher.exe" with the exe of your game!

So we'll launch

> ../steamapps/common/Fallout New Vegas/Mod.Organizer-2.4.4/ModOrganizer.exe

Instead of

> ../steamapps/common/Fallout New Vegas/FalloutNVLauncher.exe

## Making "Mod Manager Download" start downloads with Mod Organizer 2

### Modify the broker script

Modify the `modorganizer2-nxm-broker.sh` script to include the path to your target game, as well as the Steam AppID for your game. Add another case into the `case $nexus_game_id` block to set the `game_appid` and `instance_dir` vars for your target game. The value for your new case is the Nexus Game ID, as seen in the URL for hat game's Nexus page. Here's some examples:

Skyrim Special Edition Nexus page is located at `https://www.nexusmods.com/skyrimspecialedition`, and the Nexus Game ID is `skyrimspecialedition`
Fallout: New Vegas Nexus page is located at `https://www.nexusmods.com/newvegas`, and the Nexus Game ID is `newvegas`

You may want to include multiple Nexus Game IDs in your case for games like Skyrim & Skyrim Special Edition. Or when downloading mods for a Tale of Two Wastelands isntance. The script in this repo already does this for Skyrim + Skyrim Special Edition, and Fallout 3 + New Vegas + Tale of Two Wastelands.

### Modify the .desktop entry

Modify the `modorganizer2-nxm-handler.desktop` file to point to where you have saved the `modorganizer2-nxm-broker.sh` script. For myself, I just point the .desktop entry to `/home/unit537/modorganizer2-nxm-broker.sh`. Once modified, move your .desktop file to an appropriate location on your system. See: https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
