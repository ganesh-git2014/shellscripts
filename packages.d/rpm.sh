#!/bin/sh

#  rpm.sh
#  
#
#  Created by William Triest on 1/7/14.
#

if [ -z "$PACKAGER" -a -n "$(command -v rpm )" ] ; then
    PACKAGER='rpm'

    package_check_rpm() {
        rpm --quiet -q $1 >/dev/null

        if [ $? -eq 0 ] ; then
            echo 0
        else
            echo 1
        fi
    }

    package_list_rpm() {
        rpm -qa --queryformat "%{NAME}.%{ARCH}\t%{NAME}\t%{ARCH}\t%{VERSION}-%{RELEASE}\t%{VENDOR}\t%{GROUP}\n" | grep -v 'gpg-pubkey.(none)'
    }
fi


