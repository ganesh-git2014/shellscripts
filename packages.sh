#!/bin/sh

#  packages.sh
#  
#
#  Created by William Triest on 1/5/14.
#
LANG="en_US.UTF-8"

usage() {
  me=$(basename $0)
  "$me"
}

OPTIND=1
while getopts "" opt; do
  case "$opt" in
    h) usage; exit;;
  esac
done
shift $((OPTIND-1))

. common.sh

packager=`packager_check`
updater=`updater_check`

if [ $packager = 'rpm' -a $updater = 'yum' ] ; then
    package_list_rpm_yum
fi


#
#list_updates="yum check-update"
# list_security="yum list-security"
  #list="packages=\$(/bin/mktemp); updates=\$(/bin/mktemp); $list_package | sort > \$packages && $list_updates | sort >  \$updates && join -a 1 \$packages \$updates; rm \$packages; rm \$updates"
  
#elif [ $(command -v apt-get) ] ; then
  #apt-get -s --just-print upgrade | perl -nle 'printf "%-30s %-5s %-25s %-25s %-11s\n",$1,$5,$2,$3,$4  if(/^Inst\s(\S+)\s\[([^]]+)]\s\((\S+)\s(\S+)(?:\s\[([^]]+)\])?/)'
# updater="apt"
# list_packages=""
# list_updates=""
# list_security=""
#fi


echo "Package list: $list_packages"
echo "Updater list: $list_updates"
echo "Security list: $list_security"
echo "List: $list"
echo
echo

$list
#eval $list
#echo $($list)
