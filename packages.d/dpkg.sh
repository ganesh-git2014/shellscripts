#!/bin/sh

#  dpkg.sh
#  
#
#  Created by William Triest on 1/7/14.
#

#if [ -z "$PACKAGER" -a $(command -v dpkg >/dev/null) ] ; then
#    PACKAGER='dpkg'
#fi

if [ -z "$PACKAGER" -a -n "$(command -v dpkg )" ] ; then
    PACKAGER='dpkg'

    package_check_dpkg() {
        #[ -z rpm --quiet -qa $1 >/dev/null 2>&1 ]  && echo 0 || echo 1;
        dpkg -s $1 >/dev/null 2>&1
    }

    package_list_dpkg() {
        dpkg-query --show --showformat='${Package}\t${Package}\t${Architecture}\t${Version}\t\t\n'
    }
fi

