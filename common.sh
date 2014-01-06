#!/bin/sh

#  common.sh
#  
#
#  Created by William Triest on 1/6/14.
#
LANG="en_US.UTF-8"

packager_check() {
    local packager

    if [ $(command -v rpm) ] ; then
        packager="rpm"
    elif [ $(command -v dpkg) ] ; then
        packager="dpkg"
    fi

    echo $packager
}

updater_check() {
    local updater

    if [ $(command -v zypper) ] ; then
        #suse has yum install; but doesn't have yum repos configured by default so zypper needs to be before yum
        updater="zypper"
    elif [ $(command -v yum) ] ; then
        updater="yum"
    elif [ $(command -v apt-get) ] ; then
        updater="apt"
    fi

    echo $updater
}

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

package_list_rpm_yum_lister() {
    packages=`make_temp`
    updates=`make_temp`

#echo "Package list: $list_packages"
#echo "Updater list: $list_updates"
#echo "Security list: $list_security"


#    echo "|||$list_packages | sort > $packages && $list_updates | sort $updates && join -a 1 $packages $updates\n"
#exit
    $list_packages | sort > $packages && $list_updates | sort $updates && join -a 1 $packages $updates

    if [ -e $packages ] ; then
        rm $packages
    fi

    if [ -e $updates ] ; then
        rm $updates
    fi
}

package_list_rpm_yum() {
    list_packages="rpm -qa --queryformat %{NAME}.%{ARCH}\t%{VERSION}-%{RELEASE}\n"
    list_updates="yum check-update"
    list_security="yum list-security"
    list="package_list_rpm_yum_lister"
}
