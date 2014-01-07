#!/bin/sh

######!/bin/bash --posix

##########!/bin/sh

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

When autodetecting the packager and updater from a list of known packagers and updaters, it assumes that there will only be one packager and one updater.  It also assumes that only the packager is required in order to list installed programs.

    -h  Display this help information
    -p  Display installed packages only (Name, arch, version, vendor, group)
    -u  Display available updates only (name, update version, repo)
    -s  Display available security updates only (Not Implemented; TODO)
"
}

# Variables for storing argument passing
actions_list_package=0
actions_list_updates=0
actions_list_security=0
actions_list_compact=0

#Parse Arguments
OPTIND=1
while getopts "hpus" opt; do
  case "$opt" in
    h) usage; exit;;
    p) actions_list_package=1; actions_list_updates=0; actions_list_security=0;;
    u) actions_list_package=0; actions_list_updates=1; actions_list_security=0;;
    s) actions_list_package=0; actions_list_updates=0; actions_list_security=1;;
  esac
done
shift $((OPTIND-1))

# If no argument provided, default to compact form
if [ $actions_list_package -eq 0 -a $actions_list_updates -eq 0 -a $actions_list_security -eq 0 ] ; then
  actions_list_compact=1
fi

# If we're just listing packages; assume we don't need an updater
if [ $actions_list_package -eq 1 ] ; then
  UPDATER="fake"
fi

#Bring in some library functions
. `dirname $0`/packages.common.sh

#Execute the appropriate action
if [ $actions_list_compact -eq 1 ] ; then
    # cut out the first field; it varies based on distribution and what the updater will provide for joining
    #$list | cut -f 2-
    ${package_overview} | perl -nle 'print $1 if /^\S+\s+(.*)/'
elif [ $actions_list_package -eq 1 ] ; then
    ${package_list} | awk "$package_list_formater"
elif [ $actions_list_updates -eq 1 ] ; then
    ${package_updates} | awk "$package_update_formater"
elif [ $actions_list_security -eq 1 ] ; then
    ${package_sec_updates}
fi
