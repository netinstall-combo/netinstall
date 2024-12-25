#!/bin/bash
echo -ne "\033c"
# silent
source /etc/profile
# devpts
mkdir -p /dev/pts /sys /proc
mount -t devtmpfs devtmpfs  /dev
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t devpts devpts /dev/pts
# run eudev
/sbin/udevd --daemon
udevadm trigger -c add
udevadm settle
# run busybox udhcpc
for DEVICE in /sys/class/net/* ; do
    ip link set ${DEVICE##*/} up
    [ ${DEVICE##*/} != lo ] && udhcpc -b -i ${DEVICE##*/}
done
# run dropbear
mkdir -p /dev/pts
mount -t devpts devpts /dev/pts
dropbear -R -E 2>/dev/null | :
exec agetty -L 115200 -a root console
