set -e
main_menu(){
    res=$(dialog --title "Main Menu" \
        --output-fd 1 \
        --menu "Choose an option:" 15 50 4 \
        1 "Open Shell" \
        2 "Network Manager" \
        3 "Reboot")
    case $res in
      1)
        /bin/ash
        ;;
      2)
        nmtui
        ;;
      3)
        reboot -f
        ;;
    esac
}
