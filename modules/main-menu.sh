set -e
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
        --menu "Choose an option:" 0 0 0 \
        s "Open Shell" \
        n "Network Manager" \
        u "Self Update" \
        "${menu[@]}" \
        0 "Exit")
    case $res in
      s)
        /bin/bash
        ;;
      n)
        nmtui
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
        if [ $$ -eq 1 ] ; then
            reboot -f
        else
            exit 0
        fi
        ;;
    esac
    echo "Press any key to continue"
    read -n 1
}
