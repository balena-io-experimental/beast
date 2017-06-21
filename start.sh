#!/bin/bash

IMAGE="ai.png"

echo "Rendering image"

echo "HUGE ERROR!"
sleep 5
exit 1

ROTATE=${ROTATE:-0}

convert images/"$IMAGE" -rotate $ROTATE images/rotated.png
fbi -d /dev/fb1 -T 1 -noverbose -a images/rotated.png

sleep infinity

