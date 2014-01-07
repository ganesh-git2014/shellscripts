#!/bin/sh

#  yum.sh
#  
#
#  Created by William Triest on 1/7/14.
#

if [ -z "$PACKAGER" -a -n "$(command -v yum)" ] ; then
    PACKAGER='yum'

    package_check_yum() {
        yum list installed $1 >/dev/null 2>&1

        if [ $? -eq 0 ] ; then
            echo 0
        else
            echo 1
        fi
    }

    package_list_yum() {
        fields="
            BEGIN{
                join=\"\t\"
            }
        !(/Loaded plugins/ || /Installed Packages/) {
            nameArch=\$1;
            version=\$2
            split(\$1, na, \".\")
            name=na[1]
            arch=na[2]
            print nameArch join name join arch join version join join
        }"

        yum list installed | awk "$fields"
    }
fi

if [ -z "$UPDATER" -a -n "$(command -v yum )" ] ; then
    UPDATER='yum'

    package_updates_yum() {
        yum check-update
    }

    package_sec_updates_yum() {
        package_check 'yum-security' && yum list-security
    }

    package_overview_yum() {
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
