#!/usr/bin/env bash

# For Firefox on Arch Linux, you may need to run this command for Firefox to see the .desktop entry for this script:
# See: https://man.archlinux.org/man/update-desktop-database.1.en
# update-desktop-database ~/.local/share/applications

### MO2 COMPAT GAME INSTALL PATHS ###
mo2_dir_name="ModOrganizer2"

starfield_path="/run/media/jack/NVMeGamesLib1/SteamLibrary/steamapps/common/Starfield"
skyrimse_path="/run/media/jack/NVMeGamesLib1/SteamLibrary/steamapps/common/Skyrim Special Edition"
fallout4_path="/run/media/jack/NVMeGamesLib1/SteamLibrary/steamapps/common/Fallout 4"
newvegas_path="/run/media/jack/NVMeGamesLib1/SteamLibrary/steamapps/common/Fallout New Vegas"
cyberpunk_path="/run/media/jack/NVMeGamesLib1/SteamLibrary/steamapps/common/Cyberpunk 2077"

### STEAM APP IDS ###
starfield_appid=1716740
skyrimse_appid=489830
fallout4_appid=377160
newvegas_appid=22380
cyberpunk_appid=1091500

### PARSE POSITIONAL ARGS ###
nxm_url=$1; shift

### DO WORK ###
if [ -z "$nxm_url" ]; then
	zenity --ok-label=Exit --ellipsize --error --text \
		"No NXM URL provided!\n\nNXM Broker Script Location:\n$BASH_SOURCE"
	exit 1
fi

nexus_game_id=${nxm_url#nxm://}
nexus_game_id=${nexus_game_id%%/*}

case $nexus_game_id in

	starfield)
		game_appid=$starfield_appid
		instance_dir=$(readlink -f  "$starfield_path")
		;;
	skyrimspecialedition | skyrim)
		game_appid=$skyrimse_appid
		instance_dir=$(readlink -f  "$skyrimse_path")
		;;
	fallout4)
		game_appid=$fallout4_appid
		instance_dir=$(readlink -f  "$fallout4_path")
		;;
	newvegas | fallout3 | ttw)
		game_appid=$newvegas_appid
		instance_dir=$(readlink -f  "$newvegas_path")
		;;
	cyberpunk2077)
		game_appid=$cyberpunk_appid
		instance_dir=$(readlink -f  "$cyberpunk_path")
		;;
	*)
		zenity --ok-label=Exit --ellipsize --error --text \
			"NXM Broker not configured for Nexus Game ID: $nexus_game_id\n\nNXM Broker Script Location:\n$BASH_SOURCE"
		exit 1
		;;
esac

instance_dir_windowspath="Z:$(sed 's/\//\\\\/g' <<<$instance_dir)"
echo "instance_dir_windowspath = '$instance_dir_windowspath'"
process_name="$instance_dir_windowspath\\\\$mo2_dir_name\\\\ModOrganizer.exe"
echo "process_name = $process_name"
pgrep -f "$process_name"
process_search_status=$?

# Protontricks stopped working for me, so I changed to using protonhax to launch nxmhandler.exe. Something I've noticed:
# each nxmhandler.exe process does not actually exit on it's own, they spawn and keep running until the 'game' (MO2) is closed.
# I have no idea if this is the same behavior as protontricks, or if it's really even a significant problem. The good news is,
# these nxmhandler.exe processes don't ever seem to hang, they always exit when you close the 'protonhax init' process (MO2).
# So, I'm just going to leave it for now. It works, so why bother?

if [ "$process_search_status" == "0" ]; then
	echo "INFO: sending download '$nxm_url' to running Mod Organizer 2 instance"
	echo "$instance_dir/$mo2_dir_name/nxmhandler.exe"
	#download_start_output=$(protontricks-launch --appid "$game_appid" "$instance_dir/$mo2_dir_name/nxmhandler.exe" "$nxm_url")
	download_start_output=$(protonhax run $game_appid "$instance_dir/$mo2_dir_name/nxmhandler.exe" "$nxm_url")
	download_start_status=$?
else
	zenity --ok-label=Exit --ellipsize --error --text \
		"Cannot find a running Mod Organizer 2 Process for $nexus_game_id!\nPlease open Mod Organizer 2, then attempt the download again.\nUnable to start download. Exiting."
	exit 1
fi

if [ "$download_start_status" != "0" ]; then
	zenity --ok-label=Exit --ellipsize --error --text \
		"Failed to start download:\n\n$download_start_output"
	exit 1
fi
