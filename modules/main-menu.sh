set -e
main_menu(){
    res=$(dialog --title "Main Menu" \
        --output-fd 1 \
        --menu "Choose an option:" 15 50 4 \
        1 "Open Shell" \
        2 "Network Manager" \
        3 "Update Profiles" \
        3 "Self Update" \
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
        update_profile || \
          echo "Failed to update profiles." ;
          echo "Press any key to continue" ;
          read -n 1
          ;;
      3)
        update_self || \
          echo "Self-update failed." ;
          echo "Press any key to continue" ;
          read -n 1
          ;;
      0)
        reboot -f
        ;;
    esac
}
