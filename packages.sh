#!/bin/sh

#  packages.sh
#  
#
#  Created by William Triest on 1/5/14.
#
LANG="en_US.UTF-8"

usage() {
  me=$(basename $0)
  echo "$me"
}

OPTIND=1
while getopts "h" opt; do
  case "$opt" in
    h) usage; exit;;
  esac
done
shift $((OPTIND-1))

. `dirname $0`/common.sh

packager=`packager_check`
updater=`updater_check`

if [ $packager = 'rpm' -a $updater = 'yum' ] ; then
    package_list_rpm_yum
elif [ $packager = 'dpkg' -a $updater = 'apt' ] ; then
    package_list_dpkg_apt
fi

echo "Package list: $list_packages"
echo "Updater list: $list_updates"
echo "Security list: $list_security"
echo "List: $list"
echo
echo



$list
#$list_packages
#$list_updates
