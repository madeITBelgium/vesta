#!/bin/bash

#Copy all files to OS and version specific files

mkdir -p rhel/5 rhel/6 rhel/7 >/dev/null 2>&1
mkdir -p debian/7 debian/8 debian/9 >/dev/null 2>&1
mkdir -p ubuntu/12.04 ubuntu/12.10 ubuntu/13.04 ubuntu/13.10 >/dev/null 2>&1
mkdir -p ubuntu/14.04 ubuntu/14.10 ubuntu/15.04 ubuntu/15.10 >/dev/null 2>&1
mkdir -p ubuntu/16.04 ubuntu/16.10 ubuntu/17.04 ubuntu/17.10 >/dev/null 2>&1
mkdir -p ubuntu/18.04


start_dir=$(dirname $0)
cd $start_dir

list_os=$(ls | grep -v general | grep -v build)

for OS in $list_os
do
    echo $OS
    version_list=$(ls $OS | grep -v general)
    for VERSION in $version_list
    do
        cp -nR $OS/general/* $OS/$VERSION/ >/dev/null 2>&1
        cp -nR general/* $OS/$VERSION/ >/dev/null 2>&1
    done
    rm -rf $OS/general
done
rm -rf general
