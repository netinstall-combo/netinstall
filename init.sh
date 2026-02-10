#!/bin/bash
echo -ne "\033c"
# silent
source /etc/profile
# devpts
mkdir -p /dev /sys /proc
mount -t devtmpfs devtmpfs  /dev
mount -t proc proc /proc
mount -t sysfs sysfs /sys
depmod -a
if [ -d /lib/modules/$(uname -r) ] ; then
    find /lib/modules/$(uname -r)/kernel/fs -type f -exec insmod {} \; &>/dev/null
fi
# load filesystem modules
for fs in ext4 ext2 vfat xfs btrfs ; do
    modprobe $fs || true
done
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
#dropbear -R -E 2>/dev/null | :
exec agetty -L 115200 -a root console
