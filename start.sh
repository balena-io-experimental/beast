#!/bin/bash

IMAGE="ai.png"

echo "Rendering image"

ROTATE=${ROTATE:-0}

convert images/"$IMAGE" -rotate $ROTATE images/rotated.png
fbi -d /dev/fb1 -T 1 -noverbose -a images/rotated.png

sleep infinity

