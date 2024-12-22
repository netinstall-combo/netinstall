#!/bin/bash
select_distro(){
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

select_profile(){
    menu=()
    if [ ! -e /netinstall/data/profile ] ; then
        select_distro
    fi
    for sec in $(ini_list_sections < /netinstall/data/profile | grep -v distro) ; do
         menu+=("$sec" "$(ini_parse $sec description  < /netinstall/data/profile)" "false")
    done
    res=$(dialog --title "Profile Menu" \
        --output-fd 1 \
        --checklist "Choose variants:" 15 50 4 \
        "${menu[@]}")
    echo $res > /netinstall/data/options
}
