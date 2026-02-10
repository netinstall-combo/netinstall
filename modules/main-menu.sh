set -e

do_reboot(){
    i=5
    while [ $i -gt 0 ] ; do
        clear
        echo "System will reboot in $i sec"
        sleep 1
        i=$(($i-1))
    done
    reboot -f
}
main_menu(){
    echo -ne "\033c"
    menu=()
    if [ -d /netinstall/profiles ] ; then
        menu+=(
          d "Disk Menu"
          i "Install Menu"
        )
    fi
    res=$(dialog --no-cancel \
        --title "Main Menu" \
        --output-fd 1 \
        --menu "Choose an option:" -1 0 0 \
        s "Open Shell" \
        u "Self Update" \
        "${menu[@]}" \
        0 "Exit")
    case $res in
      s)
        /bin/bash
        ;;
      u)
        update_self
        ;;
      d)
        disk_menu
        ;;
      i)
        install_menu
        ;;
      0)
        do_reboot
        ;;
    esac
    echo "Press any key to continue"
    read -n 1
}
