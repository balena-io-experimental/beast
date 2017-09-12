#!/bin/bash

IMAGE="oktoberfest.jpg"

echo "Rendering image"

ROTATE=${ROTATE:-0}

echo "Doing something awful..."
sleep 10
echo "OH NO!"
exit 1

convert images/"$IMAGE" -rotate $ROTATE images/rotated.png
fbi -d /dev/fb1 -T 1 -noverbose -a images/rotated.png

sleep infinity
