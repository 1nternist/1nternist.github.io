#!/bin/bash

MyMusic=/private/var/mobile/Media/My\ Music
ios8_apps=/private/var/mobile/Containers
ios7_apps=/private/var/mobile/Applications
mobile_lib=/private/var/mobile/Library
gsmusic_dir=$mobile_lib/Grooveshark/song_cache
ios8_spotify_dir=$ios8_apps/Data/Application/*/Documents/Fetchify/Downloads
ios7_spotify_dir=$ios7_apps/*/Documents/Fetchify/Downloads
GStarget_dir=$MyMusic/GrooveShark
MBtarget_dir=$MyMusic/MusicBox
SPtarget_dir=$MyMusic/Spotify

function targetdirs () {
if [ ! -d "$GStarget_dir" ]; then
	mkdir -p "$GStarget_dir"
fi
if [ ! -d "$MBtarget_dir" ]; then
	mkdir -p "$MBtarget_dir"
fi
if [ ! -d "$SPtarget_dir" ]; then
	mkdir -p "$SPtarget_dir"
fi
}

function findmp3 () {
find "$mobile_lib" -maxdepth 1 -name '*.mp3' -execdir mv -f {} "$MBtarget_dir" \;
if [ -d "$gsmusic_dir" ]; then
	find "$gsmusic_dir" -maxdepth 1 -name '*.mp3' -execdir cp {} "$GStarget_dir" \;
fi
if [ -L "$ios7_apps" ]; then
	if [ -d "$ios8_apps" ]; then
		find "$ios8_spotify_dir" -maxdepth 1 -name '*.mp3' -execdir cp {} "$SPtarget_dir" \;
	fi
elif [ ! -L "$ios7_apps" ]; then
	if [ -d "$ios8_apps" ]; then
		find "$ios8_spotify_dir" -maxdepth 1 -name '*.mp3' -execdir cp {} "$SPtarget_dir" \;
	fi
fi
if [ -d "$ios7_apps" ]; then
	if [ ! -L "$ios7_apps" ]; then
		find "$ios7_spotify_dir" -maxdepth 1 -name '*.mp3' -execdir cp {} "$SPtarget_dir" \;
	fi
fi
}

targetdirs
findmp3
chown -R mobile:mobile "$MyMusic"
chmod -R 755 "$MyMusic"
echo
echo "All songs have been grabbed!"
echo "You can find your music in $MyMusic"
echo
exit 0
