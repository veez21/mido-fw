#!/bin/bash

user=$(grep user user.pass); user=${user#*=}
pass=$(grep pass user.pass); pass=${pass#*=}

if [ ! -n "$1" ] || [ "$1" == "-nu" ]; then
    echo "Getting latest file"
    link=$(curl -s http://en.miui.com/download-321.html | grep http://bigota.d.miui.com | head -n1 2>/dev/null)
    link=${link#*href=}; link=${link%%>*}
    link=$(echo $link | tr -d '"')
    name=${link##*'/'}
    echo "Generating $name"
    if [ -f $name ]; then
      echo "$name exists"
    else
      wget -q --show-progress $link
    fi
else
    name=$1
fi

./create_flashable_firmware.sh $name

if [ "$1" != "-nu" ]; then
  files=$(echo fw*.zip)
  wput "$files" ftp://$user:$pass@uploads.androidfilehost.com//mido-firmware/
  echo "Cleaning workspace"
  rm $files 2>/dev/null
  rm $name 2>/dev/null
fi
