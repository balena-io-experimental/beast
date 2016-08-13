#!/bin/bash

if [ ! -c /dev/fb1 ]; then
  modprobe fbtft_device name=pitft verbose=0 rotate=0

  sleep 1

  mknod /dev/fb1 c $(cat /sys/class/graphics/fb1/dev | tr ':' ' ')
fi
