#!/bin/sh

#  packages.sh
#  
#
#  Created by William Triest on 1/5/14.
#
LANG="en_US.UTF-8"

usage() {
  me=$(basename $0)
  echo "$me -- list package information

    $me -[hpus]

Lists information about installed packages.  The default is to display the complete information in a compact form (Name, Arc, Version, Vendor, Group, Update Version, Repo). Note: currently it excludes securityinformation

    -h  Display this help information
    -p  Display installed packages only (Name, arch, version, vendor, group)
    -u  Display available updates only (name, update version, repo)
    -s  Display available security updates only (Not Implemented; TODO)
"
}

actions_list_package=0
actions_list_updates=0
actions_list_security=0
actions_list_compact=0

OPTIND=1
while getopts "hpus" opt; do
  case "$opt" in
    h) usage; exit;;
    p) actions_list_package=1; actions_list_updates=0; actions_list_security=0; echo "packages";;
    u) actions_list_package=0; actions_list_updates=1; actions_list_security=0;;
    s) actions_list_package=0; actions_list_updates=0; actions_list_security=1;;
  esac
done
shift $((OPTIND-1))

if [ $actions_list_package -eq 0 -a $actions_list_updates -eq 0 -a $actions_list_security -eq 0 ] ; then
  actions_list_compact=1
fi

. `dirname $0`/common.sh

packager=`packager_check`
updater=`updater_check`

if [ $packager = 'rpm' -a $updater = 'yum' ] ; then
    package_list_rpm_yum
elif [ $packager = 'dpkg' -a $updater = 'apt' ] ; then
    package_list_dpkg_apt
fi

if [ $actions_list_compact -eq 1 ] ; then
    $list
elif [ $actions_list_package -eq 1 ] ; then
    $list_packages
elif [ $actions_list_updates -eq 1 ] ; then
    $list_updates
elif [ $actions_list_security -eq 1 ] ; then
    $list_security
fi
