#!/bin/bash

#Copy all files to OS and version specific files
#
#
#
#

mkdir rhel debian ubuntu
mkdir rhel/5 rhel/6 rhel/7
mkdir debian/7 debian/8 debian/9
mkdir ubuntu/12.04 ubuntu/12.10 ubuntu/13.04 ubuntu/13.10 ubuntu/14.04 ubuntu/14.10 ubuntu/15.04 ubuntu/15.10 ubuntu/16.04 ubuntu/16.10 ubuntu/17.04 ubuntu/17.10 ubuntu/18.04


start_dir=$(dirname $0)
cd $start_dir

list_os=$(ls | grep -v general | grep -v build)

for OS in $list_os
do
	echo $OS
    version_list=$(ls $OS | grep -v general)
    for VERSION in $version_list
    do
        cp -nR $OS/general/* $OS/$VERSION/
        cp -nR general/* $OS/$VERSION/
    done
done