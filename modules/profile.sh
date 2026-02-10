#!/bin/bash
select_distro(){
    menu=()
    rm -f /netinstall/data/options || true
    for profile in /netinstall/profiles/*.ini ; do
        menu+=($(basename $profile) "$(ini_parse distro name < $profile)")
    done
    while true ; do
        res=$(dialog --no-cancel \
            --title "Profile Menu" \
            --output-fd 1 \
            --menu "Choose a profile:" 0 0 0 \
            "${menu[@]}")
        if [ -f /netinstall/profiles/$res ] ; then
            rm -f /netinstall/data/profile || true
            ln -s ../profiles/$res /netinstall/data/profile
            break
        fi
    done
}

select_profile(){
    menu=()
    for sec in $(ini_list_sections < /netinstall/data/profile | grep -v distro) ; do
         menu+=("$sec" "$(ini_parse $sec description  < /netinstall/data/profile)" "false")
    done
    res=$(dialog --title "Profile Menu" \
        --no-cancel --output-fd 1 \
        --checklist "Choose variants:" 0 0 0 \
        "${menu[@]}")
    echo $res > /netinstall/data/options
}
