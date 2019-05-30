#!/bin/bash

MNT=mnta
FILE_PATH=$1
FILE_NAME=$(basename $FILE_PATH)

if [ -z $FILE_PATH ]; then
  echo "kernel (deb) filename required"
  exit 1
elif [ ! -f $FILE_PATH ]; then
  echo "file not found!"
  exit 1
elif expr match $FILE_NAME '^linux-image-[0-9]\+\.[0-9]\+\.[0-9]\+' > /dev/null; then
  VER=$(expr match $FILE_NAME '^linux-image-[0-9]\+\.[0-9]\+\.[0-9]\+')
  VER=$(expr substr $FILE_NAME 1 $VER)
  VER=$(expr substr $VER 13 100)
  echo "version: $VER" 
else
  echo "invalid filename pattern, must start w/ linux-image-xx.xx.xx"
  exit
fi

cp $FILE_PATH $MNT
chroot $MNT install-kernel.sh $FILE_NAME
rm -rf $MNT/$FILE_NAME

sync



