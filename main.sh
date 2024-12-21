#!/bin/ash
echo -ne "\0c"
source /etc/profile
mkdir -p /run/dbus/
# run dbus
/sbin/udevd --daemon
udevadm trigger -c add
udevadm settle
# run Network Manager
NetworkManager
exec /bin/sh