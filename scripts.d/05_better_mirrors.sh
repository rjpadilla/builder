#!/bin/bash

source lib.sh

cp mnt/img_root/etc/apt/sources.list mnt/img_root/etc/apt/sources.list.orig

cat << EOF > mnt/img_root/etc/apt/sources.list
#deb http://raspbian.raspberrypi.org/raspbian/ buster main contrib non-free rpi
deb http://mirrors.ocf.berkeley.edu/raspbian/raspbian buster main contrib non-free rpi
# Uncomment line below then 'apt-get update' to enable 'apt-get source'
#deb-src http://raspbian.raspberrypi.org/raspbian/ buster main contrib non-free rpi
EOF
