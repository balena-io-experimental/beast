#!/bin/bash

echo "Rendering image"

if [ -z "$ROTATE" ]; then
    ROTATE=0
fi

convert images/image.png -rotate $ROTATE images/rotated.png
fbi -d /dev/fb1 -T 1 -noverbose -a images/rotated.png

while true; do
    sleep 1
done
