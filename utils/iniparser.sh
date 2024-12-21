#!/bin/sh
ini_parse(){
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

ini_list_sections(){
    while read line ; do
        case $line in
          [*)
            line=${line#[}
            line=${line%]}
            echo $line
        esac
    done
}