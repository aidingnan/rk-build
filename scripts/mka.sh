#!/bin/bash

MNT=mnta
IMG=a.img

fallocate -l $((6553600 * 512)) $IMG

# 0cbc36fa-3b85-40af-946e-f15dce29d86b
# 689b853f-3749-4055-8359-054bd6e806b4
# 9bec42be-c362-4de0-9248-b198562ccd40
mkfs.ext4 -U 689b853f-3749-4055-8359-054bd6e806b4 -F $IMG

mkdir -p $MNT

mount -o loop $IMG $MNT

# expand
tar xzf cache/debase.tar.gz -C $MNT

# deploy scripts
cp scripts/target/*.sh $MNT/usr/bin

# deploy firmware
mkdir -p $MNT/lib/firmware
cp -r firmware/* $MNT/lib/firmware

# add ttyGS0 to secure tty
cat >> $MNT/etc/securetty << EOF

# USB Gadget Serial
ttyGS0
EOF

# set up fstab
cat > $MNT/etc/fstab << EOF
# <file system>                             <mount point>     <type>  <options>                   <dump>  <fsck>
UUID=0cbc36fa-3b85-40af-946e-f15dce29d86b   /mnt/persistent   ext4    defaults                    0       1
EOF

# set up hosts
cat > $MNT/etc/hosts << EOF
127.0.0.1 localhost
127.0.1.1 winas

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF

# set up hostname
cat > $MNT/etc/hostname << EOF
winas
EOF

# set up network interfaces
cat > $MNT/etc/network/interfaces << EOF
# interfaces(5) file used by ifup(8) and ifdown(8)
# Include files from /etc/network/interfaces.d:
# auto eth0
# allow-hotplug eth0
# iface eth0 inet dhcp

auto lo
iface lo inet loopback
EOF

# set up timezone
cat > $MNT/etc/timezone << EOF
Asia/Shanghai
EOF

# generate locale
chroot $MNT locale-gen "en_US.UTF-8"

# set root password
chroot $MNT bash -c "echo root:root | chpasswd"

# config network manager TODO
cat > $MNT/etc/NetworkManager/NetworkManager.conf << EOF
[main]
plugins=ifupdown,keyfile

[ifupdown]
managed=true

[device]
wifi.scan-rand-mac-address=no
EOF

# enable systemd-resolvd
chroot $MNT systemctl enable systemd-resolved
ln -sf /run/systemd/resolve/resolv.conf $MNT/etc/resolv.conf
