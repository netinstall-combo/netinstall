#!/bin/bash
gen_fstab(){
    cat /netinstall/data/parts | while read line ; do
        mnt=${line#* }
        grep "^$mnt " /proc/mounts | set "s/\/target/\//g"
    done
}
