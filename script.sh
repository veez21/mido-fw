#!/bin/bash


user=$(grep user user.pass) &&  pass=$(grep pass user.pass) && { user=${user#*=}; pass=${pass#*=}; }

nu=false
clean=false

case $1 in
	-c) clean=true; shift;;
	-nu) nu=true; shift; name=$1;;
esac

if [[ ! "$1" ]] || $nu; then
	echo "Getting latest file"
	link=$(curl -s http://en.miui.com/download-321.html | grep http://bigota.d.miui.com | head -n1 2>/dev/null)
	link=${link#*href=}; link=${link%%>*}
	link=$(echo $link | tr -d '"')
	name=${link##*'/'}
	echo "Generating $name"
	if [[ -f $name ]]; then
		echo "$name exists"
	else
		wget -q --show-progress $link
	fi
fi

chmod -R a+x $(pwd) && ./xiaomi-flashable-firmware-creator/create_flashable_firmware.sh $name

if ! $nu && [[ "$user" ]] && [[ "$pass" ]]; then
	files=$(echo fw*.zip | head -n1)
	wput "$files" ftp://$user:$pass@uploads.androidfilehost.com//mido-firmware/
fi

if $clean; then
	echo "Cleaning files"
	rm $files 2>/dev/null
	rm $name 2>/dev/null
fi
