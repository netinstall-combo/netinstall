#!/bin/sh
set -e
disk_menu(){
    while true ; do
        res=$(dialog --no-cancel --title "Disk Menu" \
            --output-fd 1 \
            --menu "Choose an option:" 0 0 0 \
            e "Erase Disk" \
            p "Edit Partitions" \
            f "Format Partition" \
            0 "Back")
        [ "$res" == 0 ] && break;
        case $res in
          e)
            erase_partition=/dev/$(TITLE="Select a disk for erase" select_disk)
            head -c 512 /dev/zero > ${erase_partition}
            ;;
          p)
            cfdisk /dev/$(TITLE="Select a disk for edit" select_disk)
            ;;
          f)
            partition=/dev/$(TITLE="Select a partition for format" select_partition)
            format_menu $partition
            ;;
        esac
    done
}

select_disk(){
    export PATH="/bin:/sbin:/usr/bin:/usr/sbin"
    menu=()
    for disk in /sys/block/* ; do
        disk=${disk/*\//}
        if echo $disk | grep "^loop" >/dev/null ; then
            continue
        fi
        if [[ "$(cat /sys/block/$disk/size)" -eq 0 ]] ; then
            continue
        fi
        size=$(lsblk -r | grep "^$disk " | cut -f4 -d" ")
        name=$(cat /sys/block/$disk/device/model)
        menu+=("$disk" " $name ($size)")
    done >/dev/null
    while [[ ! -b "/dev/$result" ]] ; do
        result=$(dialog --no-cancel \
            --output-fd 1 --menu \
            "$TITLE" 0 0 0 \
            "${menu[@]}")
    done
    echo $result
}

select_partition(){
    export PATH="/bin:/sbin:/usr/bin:/usr/sbin"
    menu=()
    for disk in /sys/block/* ; do
        disk=${disk/*\//}
        if echo $disk | grep "^loop" >/dev/null ; then
            continue
        fi
        for part in /sys/block/$disk/$disk* ; do
            if [[ -d $part ]] ; then
                part=${part/*\//}
                type=$(blkid | grep "/dev/$part:" | sed "s/.* TYPE=\"//g;s/\".*//g")
                label=$(blkid | grep "/dev/$part:" | grep LABEL | sed "s/.* LABEL=\"//g;s/\".*//g")
                if [[ "$label" == "" ]] ; then
                    label="-"
                fi
                size=$(lsblk -r | grep "^$part " | cut -f4 -d" ")
                menu+=("$part" "$type    $label    $size")
            fi
        done
    done >/dev/null
    info_label="Partition | Filesystem | Label | Size"
    while [[ ! -b "/dev/$result" ]] ; do
        result=$(dialog --no-cancel \
            --output-fd 1 --menu \
            "$TITLE\n\n${info_label}" 0 0 0 \
            "${menu[@]}")
    done
    echo $result
}

format_menu(){
    format_type=$(dialog --no-cancel \
        --output-fd 1 --menu \
        "Select filesystem format for $partition" 0 0 0 \
        "ext2" "filesystem for legacy linux rootfs" \
        "ext4" "filesystem for linux rootfs partition or storage" \
        "fat32" "filesystem for removable devices of efi partition")
    echo -ne "\033c"
    if [[ ${format_type} == "ext2" ]] ; then
        yes | mkfs.ext2 "$1"
    elif [[ ${format_type} == "ext4" ]] ; then
        yes | mkfs.ext4 -O ^has_journal -O ^metadata_csum "$1"
    elif [[ ${format_type} == "fat32" ]] ; then
        yes | mkfs.vfat "$1"
    fi
}
