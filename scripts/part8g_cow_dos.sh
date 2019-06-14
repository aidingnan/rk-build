#!/bin/bash

IMG=bin/part8g_cow_dos.img

mkdir -p bin 

rm -rf $IMG
fallocate -l 7818182656 $IMG

fdisk $IMG << EOF
o
n
p
1
131072
15269887
w
EOF

truncate -s $((64 * 512)) $IMG

fdisk -l $IMG
