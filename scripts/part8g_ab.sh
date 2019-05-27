#!/bin/bash

IMG=bin/part8g_ab.img

mkdir -p bin 

rm -rf $IMG
fallocate -l 7818182656 $IMG

fdisk $IMG << EOF
o
n
p
1
65536
2162687
n
p
2
2162688
8716287
n
p
3
8716288
15269887
w
EOF

truncate -s $((64 * 512)) $IMG

fdisk -l $IMG

