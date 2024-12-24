#!/bin/bash
echo -ne "\033c"
# silent
source /etc/profile
# run eudev
/sbin/udevd --daemon
udevadm trigger -c add
udevadm settle
# devpts
mkdir -p /dev/pts /sys /proc
mount -t devtmpfs devtmpfs  /dev
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t devpts devpts /dev/pts
# run dbus
mkdir -p /run/dbus/
dbus-daemon --system &
# run Network Manager
NetworkManager
# run dropbear
mkdir -p /dev/pts
mount -t devpts devpts /dev/pts
dropbear -R -E 2>/dev/null | :
exec agetty -L 115200 -a root console