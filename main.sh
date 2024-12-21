#!/bin/ash
echo -ne "\033c"
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
exec /bin/sh