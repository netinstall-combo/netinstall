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
modprobe ext4
source $basedir/import.sh
mkdir -p /netinstall/data
while true ; do
    main_menu || sleep 3
done