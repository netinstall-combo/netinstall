set -e
main_menu(){
    res=$(dialog --title "Main Menu" \
        --output-fd 1 \
        --menu "Choose an option:" 15 50 4 \
        1 "Open Shell" \
        2 "Network Manager" \
        3 "Update Profiles" \
        4 "Self Update" \
        5 "Disk Menu" \
        0 "Reboot")
    echo -ne "\033c"
    case $res in
      1)
        /bin/ash
        ;;
      2)
        nmtui
        ;;
      3)
        update_profile
        ;;
      4)
        update_self
        ;;
      5)
        disk_menu
        ;;
      0)
        reboot -f
        ;;
    esac
    echo "Press any key to continue"
    read -n 1
}
