#!/bin/bash
# main installation
do_call_function(){
    base=$(ini_parse distro base < /netinstall/data/profile)
    bash -ec "source  /netinstall/profiles/base/$base.sh ; $@"
}

do_install(){
    set -e
    echo -ne "\033c"
    do_call_function tool_init
    # mount parts
    cat /netinstall/data/parts | sort | while read line ; do
        mount=${line% */}
        part=${line#* }
        mkdir /target/$mount -p
        mount $part /target/$mount
    done
    # create rootfs
    do_call_function install_base_system
}