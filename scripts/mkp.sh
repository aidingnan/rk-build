#!/bin/bash

MNT=mntp
IMG=p.img

mkdir -p $MNT

fallocate -l $((2097152 * 512)) $IMG

# 0cbc36fa-3b85-40af-946e-f15dce29d86b
# 689b853f-3749-4055-8359-054bd6e806b4
# 9bec42be-c362-4de0-9248-b198562ccd40
mkfs.ext4 -U 0cbc36fa-3b85-40af-946e-f15dce29d86b -F $IMG

mount -o loop $IMG $MNT

mkdir $MNT/boot

cp scripts/u-boot/boot.cmd $MNT/boot
mkimage -C none -A arm -T script -d $MNT/boot/boot.cmd $MNT/boot/boot.scr

