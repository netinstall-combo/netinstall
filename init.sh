#!/bin/bash
echo -ne "\033c"
# silent
source /etc/profile
# run eudev
/sbin/udevd --daemon
udevadm trigger -c add
udevadm settle
# run dbus
mkdir -p /run/dbus/
dbus-daemon --system &
# run Network Manager
NetworkManager
# run dropbear
mkdir -p /dev/pts
mount -t devpts devpts /dev/pts
dropbear -R -E 2>/dev/null | :
mkdir -p /netinstall/data
exec agetty -L 115200 -a root console