#!/bin/bash


echo "Getting latest file"
link=$(curl -s http://en.miui.com/download-321.html | grep http://bigota.d.miui.com | head -n1 2>/dev/null)
link=${link#*href=}; link=${link%%>*}
link=$(echo $link | tr -d '"')
name=${link##*'\'}

echo "Generating $name"

wget --progress=bar $link

./create_flashable_firmware.sh $name
