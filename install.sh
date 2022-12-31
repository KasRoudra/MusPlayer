#!/bin/bash

# MusPlayer
# Version    : 1.0
# Author     : KasRoudra
# Github     : https://github.com/KasRoudra
# Email      : kasroudrakrd@gmail.com
# Contact    : https://m.me/KasRoudra
# Description: Play music in termux.
# Music player termux

black="\033[0;30m"
red="\033[0;31m"
green="\033[0;32m"
yellow="\033[0;33m"
blue="\033[0;34m"
purple="\033[0;35m"
cyan="\033[0;36m"
white="\033[0;37m"
nc="\033[00m"

version="1.1"

logo="${green} __  __           ____  _
${red}|  \/  |_   _ ___|  _ \| | __ _ _   _  ___ _ __
${blue}| |\/| | | | / __| |_) | |/ _' | | | |/ _ \ '__|
${yellow}| |  | | |_| \__ \  __/| | (_| | |_| |  __/ |
${purple}|_|  |_|\__,_|___/_|   |_|\__,_|\__, |\___|_|
${cyan}                                |___/  [v${version}]
${red}                               [By KasRoudra]${nc}
"

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

get_path() {
  target_path=$(echo $PATH)
  paths=$(echo $PATH | awk -F: '{ for (i=1; i<=NF; i++) {print $i}}')
  if [[ "$PATH" =~ ":" ]]; then
    target_path=$(echo "$PATH" | cut -d ":" -f1)
  fi
  for path in $paths; do
    if [[ "$path" =~ "/usr/bin" ]]; then
      target_path="$path"
      break
    fi
  done
  echo "$target_path"
}


welcome() {
  clear
  if [ -n $(command -v lolcat) ]; then
    echo -e "$logo" | lolcat
  else
    echo -e "$logo"
  fi
}

installer() {
  info "Installing files......."
  path=$(get_path)
  target="$path/musplayer"
  if [ -n "$path" ]; then
    doas cp musplayer.sh "$target"
    doas chmod 777 "$target"
  else
    error "Cannot determine path. Move file to path manually"
  fi
}

final() {
  path=$(get_path)
  target="$path/musplayer"
  if [ -e "$target" ]; then
    success "Musplayer has installed successfully."
    success "Run 'musplayer' to start it!"
  else
    error "Failed to install Musplayer"
  fi
}

main() {
  welcome
  installer
  final
}

main