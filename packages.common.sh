#!/bin/sh

#  packages.common.sh
#  
#
#  Created by William Triest on 1/7/14.
#

#TODO: Error codes
#TODO: can I packge PACKAGER and UPDATER local and have it work in this file and those in packages.d but not the calling script?

######
# ERROR CODES
######
ERR_PACKAGER_NOT_FOUND=4
ERR_UPDATER_NOT_FOUND=5
ERR_AWK_NOT_FOUND=6
######
# END ERROR CODES
######

#Bring in some library functions
. `dirname $0`/common.sh

#Setup the out formatters
if [ -n "PRETTY_PRINT" ] ; then
    package_list_formater='{printf "%-30s%-7s%-25s%-10s%-10s\n", $2, $3, $4, $5, $6 }'
    package_update_formater='{printf "%-40s%-30s%-25s\n", $1,$2,$3 }'
else
    package_list_formater='{printf "%s\t%s\t%s\t%s\t%s\n", $2, $3,$4,$5,$6 }'
    package_update_formater='{printf "%s\t%s\t%s\n", $1,$2,$3 }'
fi

for file in `dirname $0`/packages.d/*.sh
    do . $file
done

if [ -z "$PACKAGER" ] ; then
    echo "Failed to find known packager" 1>&2
    #Is it one we don't know about, not on the path, etc
    exit $ERR_PACKAGER_NOT_FOUND
fi

#Updater is purposely after packager; there may be cases when the updater needs to modify the packager (e.g. the rpm query format is setup for what yum returns.  Other updaters may need different formats (e.g. apt on Debian does package instead of Yum's package.arch; since CentOs uses yum and rpm I setup rpm to work with Yum, but if a distribution uses rpm and apt then apt might need to modify it
if [ -z "$UPDATER" ] ; then
    echo "Failed to find known updater" 1>&2
    exit $ERR_UPDATER_NOT_FOUND
    #ditto above
fi

package_check="package_check_$PACKAGER"
package_list="package_list_$PACKAGER"
package_updates="package_updates_$UPDATER"
package_sec_updates="package_sec_updates_$UPDATER"
package_overview="package_overview_$UPDATER"
