#!/bin/sh
update_profile(){
    if [ -d /netinstall/profiles ] ; then
        rm -rf /netinstall/profiles
    fi
    cd /netinstall
    wget -o profiles.zip https://github.com/netinstall-combo/profiles/archive/refs/heads/master.zip
    unzip profiles.zip
    mv profiles-master profiles
    chmod 755 -R /netinstall
    rm -f profiles.zip
    cd /
}