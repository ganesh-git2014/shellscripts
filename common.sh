#!/bin/sh

#  common.sh
#  
#
#  Created by William Triest on 1/6/14.
#
LANG="en_US.UTF-8"

check_operatingsystem() {
    KERNEL=$(uname -s)

    if [ "x$KERNEL" = "xLinux" ] ; then
        return
    else
        echo >2 "Only Linux is supported at this time. Exiting..."
    fi
}

make_temp() {
    local file

    if [ $(command -v mktemp) ] ; then
        file=`mktemp`
    elif [ $(command -v tempfile) ] ; then
        file=`tempfile`
    else
        file="/tmp/$(basename $0).$RANDOM.txt"
    fi

    echo $file
}



