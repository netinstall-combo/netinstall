set -e
install_menu(){
    while true ; do
        res=$(dialog --title "Install Menu" \
            --output-fd 1 \
            --menu "Choose an option:" 15 50 4 \
            1 "Select Partition" \
            2 "Select Profile" \
            0 "Back")
        echo -ne "\033c"
        case $res in
          1)
            partition_menu
            ;;
          2)
            select_profile
            ;;
          0)
            break
            ;;
        esac
    done
}