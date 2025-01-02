# simple-mod-organizer-linux
A K.I.S.S. Mod Organizer 2 Setup for Linux using Steam.

# Requirements

- [ProtonHax](https://github.com/aoleg94/protonhax)
- [ProtonTricks](https://github.com/Matoking/protontricks)
- [Zenity](https://gitlab.gnome.org/GNOME/zenity)

## Download Mod Organizer 2

Download mod Organizer 2 from the [Mod Organizer 2 Releases](https://github.com/Modorganizer2/modorganizer/releases)

As of 2024-04-24, you'll want v2.5.0, specifically the the ` Mod.Organizer-2.5.0.7z ` file.

Extract this archive into a folder named `ModOrganizer2`, and move this folder inside of your game's base directory.

(For example: `.../steamapps/common/Fallout 4/ModOrganizer2/`)

## Redirect Steam to launch Mod Organizer 2

In your Steam library, navigate to the game you want to use Mod Organizer 2 with. Right click the game, click "Properties" and enter the following line (modify as needed) into the "Launch Options":

> eval $(echo "protonhax init %command%" | sed 's+Fallout4Launcher.exe+/ModOrganizer2/ModOrganizer.exe+g')

Note that this line is specifically structured to trick steam into launching ModOrganizer.exe instead of your game's exe!

In this case, I am 'replacing' "Fallout4Launcher.exe" (located in the game's base directory) with "./ModOrganizer2/ModOrganizer.exe" (located inside the "ModOrganizer2" folder that is inside of the base game's directory). **Be sure to replace "Fallout4Launcher.exe" with the exe of your game!**

*So we'll launch*

> ../steamapps/common/Fallout 4/ModOrganizer2/ModOrganizer.exe

*Instead of*

> ../steamapps/common/Fallout 4/Fallout4Launcher.exe

## Making "Mod Manager Download" button start downloads with Mod Organizer 2

This section covers how to make the "Mod Manager Download" button on NexusMods ([https://nexusmods.com/](https://nexusmods.com/)) work with your web browser in linux.

### Modify the broker script

Modify the `modorganizer2-nxm-broker.sh` script to include the path to your target game, as well as the Steam AppID for your game. Add another case into the `case $nexus_game_id` block to set the `game_appid` and `instance_dir` vars for your target game. The value for your new case is the Nexus Game ID, as seen in the URL for hat game's Nexus page. Here's some examples:

Skyrim Special Edition Nexus page is located at `https://www.nexusmods.com/skyrimspecialedition`, and the Nexus Game ID is `skyrimspecialedition`

Fallout: New Vegas Nexus page is located at `https://www.nexusmods.com/newvegas`, and the Nexus Game ID is `newvegas`

You may want to include multiple Nexus Game IDs in your case for games like Skyrim & Skyrim Special Edition. Or when downloading mods for a Tale of Two Wastelands isntance. The script in this repo already does this for Skyrim + Skyrim Special Edition, and Fallout 3 + New Vegas + Tale of Two Wastelands. This has already been done for these specific games, but you will need to do this yourself for other combinations of games.

### Modify the .desktop entry

Modify the `modorganizer2-nxm-handler.desktop` file to point to where you have saved the `modorganizer2-nxm-broker.sh` script. For myself, I just point the .desktop entry to `/home/jack/modorganizer2-nxm-broker.sh`. Once modified, move your .desktop file to an appropriate location on your system (For example: `~/.local/share/applications`). See: FreeDesktop.org's [desktop-enry-spec](https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html)

### Update your XDG-MIME Database

If the broker script isn't executing when you press the "Mod Manager Download" button, open a terminal and run this command: `update-desktop-database {.desktop file location}` where `{.desktop file location}` is the directory containing your .desktop file! (For example: `~/.local/share/applications`)

If your system does not have the `update-desktop-database` command, see FreeDesktop.org's [desktop-file-utils](https://www.freedesktop.org/wiki/Software/desktop-file-utils/)
