#!/bin/ash
cd /
uri="https://dl-cdn.alpinelinux.org/alpine/edge/releases/$(uname -m)/"
tarball=$(wget -O - "$uri" |grep "alpine-minirootfs" | grep "tar.gz<" | \
    sort -V | tail -n 1 | cut -f2 -d"\"")
wget -O - "$uri/$tarball" | tar -xvzf -
apk add dialog agetty bash ca-certificates
# install netinstall
wget -O /tmp/netinstall.zip https://github.com/netinstall-combo/netinstall/archive/refs/heads/master.zip
unzip /tmp/netinstall.zip
mv netinstall-master /netinstall/
rm -f /tmp/netinstall.zip
chmod 755 -R /netinstall
# change shell with netinstall combo main menu
echo "/netinstall/main.sh" >> /etc/shells
sed -i "/^root:x:*/d" /etc/passwd
echo "root:x:0:0:root:/:/netinstall/main.sh" >> /etc/passwd
exec /netinstall/init.sh
