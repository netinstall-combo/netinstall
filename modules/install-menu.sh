set -e
install_menu(){
    while true ; do
        menu=()
        if [ -f /netinstall/data/profile ] && \
           [ -f /netinstall/data/username ] && \
           [ -f /netinstall/data/grub ] && \
           grep "^/ " /netinstall/data/parts >/dev/null ; then
            menu=(i "Start Installlation")
        fi
        res=$(dialog --no-cancel --title "Install Menu" \
            --output-fd 1 \
            --menu "$(get_install_info)" 0 0 0 \
            p "Select Partition" \
            d "Select Distribution" \
            o "Select Options" \
            g "Select Grub Disk" \
            u "Select Username and Password" \
            "${menu[@]}" \
            0 "Back")
        echo -ne "\033c"
        case $res in
          p)
            partition_menu
            ;;
          d)
            select_distro
            ;;
          o)
            select_profile
            ;;
          g)
            select_grub
            ;;
          u)
            select_username
            ;;
          i)
            do_install
            ;;
          0)
            break
            ;;
        esac
    done
}

select_username(){
    dialog --no-cancel --title "Install Menu" \
            --output-fd 1 \
            --inputbox "Provide an username" 0 0 "pingu" > /netinstall/data/username
    dialog --no-cancel --title "Install Menu" \
            --output-fd 1 \
            --inputbox "Provide a password" 0 0 "" > /netinstall/data/password
}

get_install_info(){
    if [ -e /netinstall/data/profile ] ; then
        echo "Distro: $(ini_parse distro name < /netinstall/data/profile)"
        echo "Option: $(cat /netinstall/data/options)"
        echo "Grub: $(cat /netinstall/data/grub)"
    fi
    if [ -f /netinstall/data/username ] ; then
        echo "Username: $(cat /netinstall/data/username)"
    fi
}
