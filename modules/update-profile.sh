#!/bin/sh
update_profile(){
    if [ -d /netinstall/profiles ] ; then
        rm -rf /netinstall/profiles
    fi
    cd /netinstall
    wget -O profiles.zip https://github.com/netinstall-combo/profiles/archive/refs/heads/master.zip
    unzip profiles.zip
    mv profiles-master profiles
    chmod 755 -R /netinstall
    rm -f profiles.zip
    cd /
}

update_self(){
    apk upgrade
    wget -O /tmp/netinstall.zip https://github.com/netinstall-combo/netinstall/archive/refs/heads/master.zip
    cd /
    unzip /tmp/netinstall.zip
    rm -rf /netinstall
    mv netinstall-master /netinstall/
    update_profile
    exec /netinstall/main.sh
}