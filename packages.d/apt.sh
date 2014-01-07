#!/bin/sh

#  apt.sh
#  
#
#  Created by William Triest on 1/7/14.
#

if [ -z "$UPDATER" ] ; then
    if [ $(command -v apt-get ) ] ; then
        UPDATER='apt'
    fi

    package_updates_apt() {
        apt-get -s --just-print upgrade | perl -nle 'print "$1\t$2\t$3\t$4" if /^Inst\s(\S+)\s.*\((\S+).*\s(\S+)\s\[[^]]+\]\)$/'
    }

    package_sec_updates_apt() {
        ls > /dev/null
    }

    package_overview_apt() {
        packages=`make_temp`
        updates=`make_temp`

        ${package_list} | sort > $packages && ${package_updates} | sort > $updates && join -a 1 $packages $updates

        if [ -e $packages ] ; then
            rm $packages
        fi

        if [ -e $updates ] ; then
            rm $updates
        fi
    }
fi


