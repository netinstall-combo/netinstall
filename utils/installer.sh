#!/bin/bash
# main installation
do_call_function(){
    base=$(ini_parse distro base < /netinstall/data/profile)
    bash -ec "source /netinstall/profiles/base/$base.sh ; $*"
}

fail(){
    echo "Installation Failed!"
    exec sleep inf
}

do_install(){
    set -e
    echo -ne "\033c"
    do_call_function tool_init
    # mount parts
    cat /netinstall/data/parts | sort | while read line ; do
        mount=${line% *}
        part=${line#* }
        if [[ -b "$part" ]] ; then
            mkdir /target/$mount -p
            mount $part /target/$mount || fail
        fi
    done
    # create rootfs
    do_call_function install_base_system
    # bind mount
    for dir in dev sys proc run ; do
        mount --bind /$dir /target/$dir
    done
    do_call_function install_package $(ini_parse distro packages < /netinstall/data/profile)
    for opt in $(cat /netinstall/data/options) ; do
        do_call_function remove_package $(ini_parse $opt remove < /netinstall/data/profile)
        do_call_function install_package $(ini_parse $opt install < /netinstall/data/profile)
        chroot /target sh -c "$(ini_parse $opt run < /netinstall/data/profile)"
        do_call_function configure $opt
    done
    do_call_function update_initramfs
    do_call_function create_user
    # fstab
    gen_fstab > /target/etc/fstab
    sed -i ".*GRUB_CMDLINE_LINUX_DEFAULT=.*/d" /target/etc/default/grub
    rootfstype=$(cat /target/etc/fstab | grep " / " | cut -f3 -d" ")
    sed -i "GRUB_CMDLINE_LINUX_DEFAULT=\"quiet rootfstype=$rootfstype\"" >> /target/etc/default/grub
    # install grub
    if [ -d /sys/firmware/efi ] ; then
        mount -t efivarfs efivarfs /target/sys/firmware/efi/efivars/
    fi
    chroot /target grub-install /dev/$(cat /netinstall/data/grub)
    chroot /target grub-mkconfig -o /boot/grub/grub.cfg
    echo "tmpfs /tmp tmpfs defaults,rw 0 0" >> /target/etc/fstab
    if [[ -d /sys/firmware/efi ]] ; then
        umount -lf /target/sys/firmware/efi/efivars/
    fi

    # bind umount
    for dir in dev sys proc run ; do
        umount -lf /target/$dir
    done
    sync
    umount -lf /target
    dialog --output-fd 1 --msgbox "Installation finished." 0 0
    i=5
    while [ $i -gt 0 ] ; do
        clear
        echo "System will reboot in $i sec"
        sleep 1
        i=$(($i-1))
    done

    reboot -f
}