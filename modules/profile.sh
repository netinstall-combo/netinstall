#!/bin/bash
select_profile(){
    menu=()
    for profile in /netinstall/profiles/*.ini ; do
        menu+=($(basename $profile) "$(ini_parse distro name < $profile)")
    done
    while true ; do
        res=$(dialog --title "Profile Menu" \
            --output-fd 1 \
            --menu "Choose a profile:" 15 50 4 \
            "${menu[@]}")
        if [ -f /netinstall/profiles/$res ] ; then
            rm -f /netinstall/data/profile
            ln -s ../profiles/$res /netinstall/data/profile
            break
        fi
    done
}
