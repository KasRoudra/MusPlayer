#!/data/data/com.termux/files/usr/bin/bash
# MusPlayer [ Termux Music ]
# Author: Original- Bagaz Mukti, Modified by KasRoudra
# Github: github.com/BagazMukti/ , github.com/KasRoudra
# Website: bagaz.org , N/A
# Contact: me@bl33dz.me, N/A
cd ~
mkdir Music
export DIR="~/Music"

figlet MusPlayer

loop=true

while $loop; do
	trap '' 2
	read -p "musplayer> " cmd
	if [ "$cmd" = "help" ]; then
		echo -e "List of commands:
> list           show playlist
> play <number>  play music
> play all       play all music on playlist
> chdir <path>   change playlist directory (current: $DIR)
> help           show this help
> exit           exit from this program\n"
	elif [ "$cmd" = "list" ]; then
		getlist=$(ls $DIR | grep mp3)
		replace=${getlist// /%%}
		n=1
		for music in $replace; do
			echo "[$n] ${music//%%/ }"
			((n++))
		done
		echo
	elif echo "$cmd" | grep -q "play"; then
		arg=$(echo "$cmd" | cut -d " " -f 2)
		getlist=$(ls $DIR | grep mp3)
		replace=${getlist// /%%}
		list=()
		for m in $replace; do
			list+=("$m")
		done
		if [ $arg = "all" ]; then
			for ms in $replace; do
				trap 'break' 2
				mpv "$DIR/${ms//%%/ }"
			done
		else
			music=${list[(($arg-1))]}
			mpv "$DIR/${music//%%/ }"
		fi
		echo
	elif echo "$cmd" | grep -q "chdir"; then
		export DIR="$(echo "$cmd" | cut -d " " -f 2)"
		echo "Directory changed!"
		echo
	elif [ "$cmd" = "exit" ]; then
		loop=false
	else
		echo "Sorry, wrong input! Please type \"help\""
	fi
done
