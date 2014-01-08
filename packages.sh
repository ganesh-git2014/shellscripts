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

    -t  Terse Output format Use tabs instead of spaces; smaller but harder to read
"
}

# Variables for storing argument passing
PRETTY_PRINT=0
ACTION='package_overview'

#Parse Arguments
OPTIND=1
while getopts "hpust" opt; do
  case "$opt" in
    h) usage; exit;;
    p) ACTION='package_list';;
    u) ACTION='package_updates';;
    s) ACTION='packge_sec_updates';;
    t) PRETTY_PRINT=1
  esac
done
shift $((OPTIND-1))

# If we're just listing packages; assume we don't need an updater
if [ $ACTION = 'package_list' ] ; then
  UPDATER="fake"
fi

#Bring in some library functions
. `dirname $0`/packages.common.sh

#Execute the appropriate action
if [ $ACTION = 'package_overview' ] ; then
    ${package_overview} | awk "$package_compact_formater"
elif [ $ACTION = 'package_list' ] ; then
    ${package_list} | awk "$package_list_formater"
elif [ $ACTION = 'package_updates' ] ; then
    ${package_updates} | awk "$package_update_formater"
elif [ $ACTION = 'package_sec_updates' ] ; then
    #TODO: add an awk formater
    ${package_sec_updates}
fi
