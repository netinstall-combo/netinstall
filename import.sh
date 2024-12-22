#!/bin/bash
# import util functions
for file in /$basedir/utils/*.sh ; do
    source $file
done
for file in /$basedir/modules/*.sh ; do
    source $file
done
