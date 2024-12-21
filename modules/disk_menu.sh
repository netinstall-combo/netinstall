set -e
disk_menu(){
    while true ; do
        res=$(dialog --title "Disk Menu" \
            --output-fd 1 \
            --menu "Choose an option:" 15 50 4 \
            1 "Erase Disk" \
            2 "Edit Partitions" \
            3 "Format Partition" \
            0 "Back")
        [ "$res" == 0 ] && break;
        case $res in
          1)
            : fixme
            ;;
          2)
            : fixme
            ;;
          3)
            : fixme
            ;;
        esac
    done
}