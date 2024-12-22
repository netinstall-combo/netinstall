partition_menu(){
    while true ; do
        res=$(dialog --no-cancel \
            --output-fd 1 --menu \
            "Partition Menu" 0 0 0 \
            "1" "Add Partition" \
            $(cat /netinstall/data/parts) \
            "0" "Back")
        [ "$res" == "0" ] && break
        if [ "$res" == "1" ] ; then
            select_mountpoint
        else
             sed -i "s|^$res .*||g" /netinstall/data/parts
        fi
    done
}

select_mountpoint(){
    partition=/dev/$(TITLE="Select a partition for mountpoint" select_partition)
    mountpoint=$(mountpoint_menu)
    sed -i "^$partition/d" /netinstall/data/parts || true
    echo -e "$partition $mountpoint" >> /netinstall/data/parts
}

mountpoint_menu(){
    if [[ -d /sys/firmware/efi ]] ; then
        efi_mounts=("/boot/efi" "Boot directory for uefi")
    fi
    result=$(dialog --no-cancel \
                --output-fd 1 --menu \
                "Select a mountpoint" 0 0 0 \
                "/" "Root filesystem" \
                "${efi_mounts[@]}" \
                "custom" "Custom directory")
    if [[ "$result" == "custom" ]] ; then
        result=""
        while ! mkdir -p "$result" ; do
            result=$(dialog --output-fd 1 --inputbox "Enter new mountpoint" 0 0)
        done
    fi
    echo $result
}
