#!/usr/bin/env bash

### MO2 COMPAT GAME INSTALL PATHS ###
mo2_dir_name="Mod.Organizer-2.4.4"

newvegas_path="/run/media/unit537/NVMeGamesLib1/SteamLibrary/steamapps/common/Fallout New Vegas/"
fallout4_path="/run/media/unit537/NVMeGamesLib1/SteamLibrary/steamapps/common/Fallout 4/"
skyrimse_path="/run/media/unit537/NVMeGamesLib1/SteamLibrary/steamapps/common/Skyrim Special Edition/"
cyberpunk_path="/run/media/unit537/NVMeGamesLib1/SteamLibrary/steamapps/common/Cyberpunk 2077/"

### STEAM APP IDS ###
newvegas_appid=22380
fallout4_appid=377160
skyrimse_appid=489830
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

	newvegas | fallout3 | ttw)
		game_appid=$newvegas_appid
		instance_dir=$(readlink -f  "$newvegas_path")
		;;
	fallout4)
		game_appid=$fallout4_appid
		instance_dir=$(readlink -f  "$fallout4_path")
		;;
	skyrimspecialedition | skyrim)
		game_appid=$skyrimse_appid
		instance_dir=$(readlink -f  "$skyrimse_path")
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
process_name="$instance_dir_windowspath\\\\$mo2_dir_name\\\\ModOrganizer.exe"
pgrep -f "$process_name"
process_search_status=$?

if [ "$process_search_status" == "0" ]; then
	echo "INFO: sending download '$nxm_url' to running Mod Organizer 2 instance"
	download_start_output=$(protontricks-launch --appid "$game_appid" "$instance_dir/$mo2_dir_name/nxmhandler.exe" "$nxm_url")
	download_start_status=$?
else
	echo "INFO: starting Mod Organizer 2 to download '$nxm_url'"
	download_start_output=$(steam -applaunch "$game_appid" "$nxm_url")
	download_start_status=$?
fi

if [ "$download_start_status" != "0" ]; then
	zenity --ok-label=Exit --ellipsize --error --text \
		"Failed to start download:\n\n$download_start_output"
	exit 1
fi

