#!/bin/bash
set -e
trap '' SIGINT
set -o ignoreeof
###### netinstall combo ######
# clear screen
echo -ne "\033c"
# create shell
echo "Welcome to Netinstall-Combo"
if [ "$basedir" == "" ] ; then
    basedir="/netinstall"
fi
# import util functions
for file in /$basedir/utils/*.sh ; do
    source $file
done
for file in /$basedir/modules/*.sh ; do
    source $file
done
mkdir -p /netinstall/data
while true ; do
    main_menu || sleep 3
done