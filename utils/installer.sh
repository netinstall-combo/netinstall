#!/bin/bash
# main installation
do_call_function(){
    bash -ec "source /netinstall/data/profile ; $@"
}

do_install(){
    do_call_function tool_init
    # mount parts
    cat /netinstall/data/parts | sort | while read line ; do
        mount=${line% */}
        part=${line#* }
        mkdir /target/$mount -p
        mount $part $mount
    done
    # create rootfs
    do_call_function install_base_system
}