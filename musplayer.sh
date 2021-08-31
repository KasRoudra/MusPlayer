#!/data/data/com.termux/files/usr/bin/bash

# MusPlayer
# Version    : 1.0
# Author     : KasRoudra
# Github     : https://github.com/KasRoudra
# Email      : kasroudrakrd@gmail.com
# Contact    : https://m.me/KasRoudra
# Description: Play music in termux.
# Music player termux


white="\033[1;37m"
red="\033[1;31m"
green="\033[1;32m"
yellow="\033[1;33m"
purple="\033[0;35m"
cyan="\033[0;36m"
blue="\033[1;34m"

info="${cyan}[${white}+${cyan}] ${yellow}"
ask="${cyan}[${white}?${cyan}] ${purple}"
error="${cyan}[${white}!${cyan}] ${red}"
success="${cyan}[${white}√${cyan}] ${green}"

re='^[0-9]+$'

logo="${green} __  __           ____  _
${red}|  \/  |_   _ ___|  _ \| | __ _ _   _  ___ _ __
${blue}| |\/| | | | / __| |_) | |/ _' | | | |/ _ \ '__|
${yellow}| |  | | |_| \__ \  __/| | (_| | |_| |  __/ |
${purple}|_|  |_|\__,_|___/_|   |_|\__,_|\__, |\___|_|
${cyan}                                |___/
${red}                               [By KasRoudra]
"

export REPEAT=false
export SHUFFLE=false
export NUMS=0
export RAND=0

if [ `pidof mpv > /dev/null 2>&1` ]; then
    killall mpv
fi
if [ -d "/data/data/com.termux/files/home" ]; then
    if ! [ -d "/sdcard/Music" ]; then
        cd /sdcard
        mkdir Music
        export DIR="/sdcard/Music"
    else
        export DIR="/sdcard/Music"
    fi
else
    export DIR="$HOME/Music"
fi

if ! [ `command -v mpv` ]; then
    echo -e "\n${info}Installing mpv.....\n"
    pkg install mpv -y
    if [ `command -v mpv` ]; then
	    echo -e "\n${success}Mpv installed!\n"
    else
	    echo -e "\n${error}Mpv installation failed!\n"
	    exit
    fi
fi
clear
echo -e "$logo"
while true; do
	trap '' 2
	printf "\n${yellow}MusPlayer > ${purple}"
	read cmd
	if [ "$cmd" = "help" ]; then
		echo -e "\n${info}${cyan}List of commands:${yellow}
${purple}> help           ${yellow}Shows this help
${purple}> list           ${yellow}Shows music list
${purple}> chdir${green} <path>${yellow}   Changes music list directory (current: $blue$DIR$yellow)
${purple}> play${green} <number>${yellow}  Plays that muscic
${purple}> play all       ${yellow}Plays all music
${purple}> repeat         ${yellow}Repeats the music (current: $blue$REPEAT$yellow)
${purple}> shuffle        ${yellow}Shuffles all music (current: $blue$SHUFFLE$yellow)
${purple}> exit           ${yellow}Exit from this program"
	elif [ "$cmd" = "list" ]; then
	echo
		getlist=$(ls $DIR | grep mp3)
		replace=${getlist// /%%}
		n=1
		if ! [[ $replace == "" ]]; then
		    for music in $replace; do
		        if (( $n % 2 == 0 )) ; then
		    	    echo -e "${yellow}[$n]${blue} ${music//%%/ }"
		        else
		            echo -e "${green}[$n]${purple} ${music//%%/ }"
		        fi
			((n++))
		    done
		else
		    echo -e "${error}No music here!$blue($DIR)"
		fi
	elif echo "$cmd" | grep -q "chdir"; then
		path="$(echo "$cmd" | cut -d " " -f 2)"
		if [[ -d "$path" ]]; then
		    export DIR="${path}"
		    echo -e "\n${success}Directory changed!"
		else
		    echo -e "\n${error}Path do not exist!"
		fi
	elif echo "$cmd" | grep -q "play"; then
		arg=$(echo "$cmd" | cut -d " " -f 2)
		getlist=$(ls $DIR | grep mp3)
		replace=${getlist// /%%}
		list=()
		for m in $replace; do
			list+=("$m")
		done
		while true; do
		if [ $arg = "all" ]; then
		    if ! [[ $list == "" ]]; then
		    echo -e "\n${success}Playing all....."
		    if $SHUFFLE; then
		    while true; do
		        trap 'break' 2
		        cd $DIR
		        export NUMS=`ls *.mp3 | wc -l`
		        export RAND=`shuf -i 1-${NUMS} -n 1`
		        music=${list[(($RAND))]}
		        echo -e "\n${success}${blue}${music//%%/ }\n"
		        mpv "$DIR/${music//%%/ }"
		        done
		    break
		    else
			    for ms in $replace; do
			        echo -e "\n${success}${blue}${ms//%%/ }\n"
				    trap 'break' 2
				    mpv "$DIR/${ms//%%/ }"
			    done
			break
			fi
			else
			   echo -e "\n${error}No music!"
			   break
			fi
		elif ! [[ $arg =~ $re ]]; then
		    echo -e "\n${error}Not a number!"
		    break
		else
			music=${list[(($arg-1))]}
			if [[ ${music//%%/ } == "" ]]; then
		        echo -e "\n${error}Music not found!"
		    else
			    echo -e "\n${success}Playing ${music//%%/ }\n"
			    if $REPEAT; then
			    while true ; do
			    trap 'break' 2
			    mpv "$DIR/${music//%%/ }"
			    done
			    else
			    trap 'break' 2
			    mpv "$DIR/${music//%%/ }"
			    fi
			fi
			break
		fi
		done
	elif echo "$cmd" | grep -q "repeat"; then
	    if [ $REPEAT = false ]; then
	        export REPEAT=true
	        echo -e "\n${success}Repeat turned on!"
	    else
	        export REPEAT=false
	        echo -e "\n${success}Repeat turned off!"
	    fi
	elif echo "$cmd" | grep -q "shuffle"; then
	    if [ $SHUFFLE = false ]; then
	        export SHUFFLE=true
	        echo -e "\n${success}Shuffle turned on!"
	    else
	        export SHUFFLE=false
	        echo -e "\n${success}Shuffle turned off!"
	    fi
    elif [ "$cmd" = "clear" ]; then
		clear
		echo -e "$logo"
	elif [ "$cmd" = "exit" ]; then
		echo -e "${white}"
		exit
	else
		echo -e "\n${error}Sorry, wrong input! Please type 'help'"
	fi
done
