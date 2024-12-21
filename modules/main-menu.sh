set -e
main_menu(){
    res=$(dialog --title "Main Menu" \
        --output-fd 1 \
        --menu "Choose an option:" 15 50 4 \
        1 "Open Shell" \
        2 "Network Manager" \
        3 "Update Profiles" \
        0 "Reboot")
    case $res in
      1)
        /bin/ash
        ;;
      2)
        nmtui
        ;;
      3)
        echo -ne "\033c"
        if ! update_profile ; then
            echo "Failed to update profiles."
            echo "Press any key to continue"
            read -n 1
        fi
        ;;
      0)
        reboot -f
        ;;
    esac
}
