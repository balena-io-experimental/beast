#!/bin/bash

src=$1
ffmpeg -vcodec png -i $src -vcodec rawvideo -f rawvideo -pix_fmt rgb565le -vf scale=240:320 $(basename "$src" .png).raw
