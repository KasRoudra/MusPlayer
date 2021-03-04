#!/data/data/com.termux/files/usr/bin/bash
echo -n "checking mpv package... "
if mpv --version | grep -q "mpv/MPlayer/mplayer2"; then
	echo "ok"
else
	echo "Error!!"
	echo "Installing mpv... "
	apt install --force-yes mpv
	if mpv --version | grep -q "mpv/MPlayer/mplayer2"; then
		echo "mpv installed... "
	else
		echo "Failed to install mpv...\nExitting"
		exit
	fi
fi
_path=$(echo $PATH | cut -d ":" -f 1)
echo "$ cp musplayer.sh $_path/musplayer"
cp musplayer.sh $_path/musplayer
echo "$ chmod +x $_path/musplayer"
chmod +x $_path/musplayer
echo "$ termux-fix-shebang $_path/musplayer"
termux-fix-shebang $_path/musplayer
echo "> Musplayer installed successfully!"
echo "> Type \"musplayer\" and enter to run..."
