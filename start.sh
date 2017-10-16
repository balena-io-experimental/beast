#!/bin/bash

IMAGE=${IMAGE:-"moby.png"}

echo "Rendering image"

ROTATE=${ROTATE:-0}
if [ -z ${RESIZE+x} ]; then RESIZE_STR=""; else RESIZE_STR="-resize ${RESIZE}!"; fi

convert images/"$IMAGE" -rotate $ROTATE ${RESIZE_STR} images/rotated.png
fbi -d /dev/fb1 -T 1 -noverbose -a images/rotated.png

while true; do
    sleep 1
done
