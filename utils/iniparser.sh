#!/bin/sh
parse(){
    section="$1"
    value="$2"
    found="false"
    while read line ; do
        case $line in
            [*)
               	if [ "$line" == "[$section]" ] ; then
                    found="true"
                fi
            ;;
            "$value"=*)
                if [ "$found" == "true" ] ; then
                    ret=${line#*=}
                    echo $(eval echo $ret)
                    return
                fi
            esac
    done < /dev/stdin
}
