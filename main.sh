#!/bin/bash
set -e
trap '' SIGINT
set -o ignoreeof
###### netinstall combo ######
export SHELL=/bin/bash
export TERM=linux
# clear screen
echo -ne "\033c"
# create shell
echo "Welcome to Netinstall-Combo"
if [ "$basedir" == "" ] ; then
    basedir="/netinstall"
fi
find /lib/modules/$(uname -r)/kernel/fs -type f -exec insmod {} \; &>/dev/null
source $basedir/import.sh
mkdir -p /netinstall/data
if grep init= /proc/cmdline >/dev/null; then
    echo -ne "\033c"

    init="$(cat /proc/cmdline | tr ' ' '\n' | grep 'init=')"
    init=${init/*=/}
    if echo "$init" | grep "://" >/dev/null; then
        wget "$init" -O - | bash -e
    elif [ -f "$init" ] ; then
       bash -e "$init"
    else
        echo "init not found"
        echo "$init"
    fi
    echo "press any key to continue"
    read -n 1
fi
while true ; do
    main_menu || sleep 3
done
