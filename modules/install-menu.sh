set -e
install_menu(){
    while true ; do
        res=$(dialog --title "Install Menu" \
            --output-fd 1 \
            --menu "$(get_install_info)" 15 50 4 \
            1 "Select Partition" \
            2 "Select Profile" \
            3 "Select Username and Password" \
            0 "Back")
        echo -ne "\033c"
        case $res in
          1)
            partition_menu
            ;;
          2)
            select_profile
            ;;
          3)
            select_username
            ;;
          0)
            break
            ;;
        esac
    done
}

select_username(){
    dialog --title "Install Menu" \
            --output-fd 1 \
            --inputbox "Provide an username" 0 0 "pingu" > /netinstall/data/username
    dialog --title "Install Menu" \
            --output-fd 1 \
            --inputbox "Provide a password" 0 0 "" > /netinstall/data/password
}

get_install_info(){
    if [ -e /netinstall/data/profile ] ; then
        distro=$(basename $(readlink /netinstall/data/profile))
        echo "Distro: $distro"
        echo "Option: $(cat /netinstall/data/options)"
    fi
    if [ -f /netinstall/data/username ] ; then
        echo "Username: $(cat /netinstall/data/username)"
    fi
}
