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
        mount=${line% *}
        part=${line#* }
        mkdir /target/$mount -p
        mount $part /target/$mount
    done
    # create rootfs
    do_call_function install_base_system
    do_call_function install_package $(ini_parse distro packages < /netinstall/data/profile)
    for opt in $(cat /netinstall/data/options) ; do
        do_call_function remove_package $(ini_parse $opt remove < /netinstall/data/profile)
        do_call_function install_package $(ini_parse $opt install < /netinstall/data/profile)
    done
}