#!/bin/bash

CURRENTVESION=$(php -v | awk '{print $2}' | head -1)
echo "Current PHP Version: $CURRENTVESION"

#Get centos version 7, 8 or 9
os=$(cut -f 1 -d ' ' /etc/redhat-release)
release=$(grep -o "[0-9.]*" /etc/redhat-release |head -n1)

#centos 7
if [ "$release" == "7" ]; then
    yum install -y epel-release > /dev/null
    yum install -y yum-utils > /dev/null
    yum-config-manager --disable remi-php71 > /dev/null
    yum-config-manager --disable remi-php72 > /dev/null
    yum-config-manager --disable remi-php73 > /dev/null
    yum-config-manager --enable remi-php74 > /dev/null
    yum update -y php > /dev/null
fi

#centos 8
if [ "$release" == "8" ]; then
    dnf install -y epel-release > /dev/null
    dnf install -y dnf-utils > /dev/null
    dnf module reset php > /dev/null
    dnf module enable php:remi-7.4 > /dev/null
    dnf update -y php > /dev/null
fi

#centos 9
if [ "$release" == "9" ]; then
    dnf module reset php > /dev/null
    dnf module enable php:remi-8.3 > /dev/null
    dnf update -y php > /dev/null
fi

service php-fpm restart > /dev/null 2>&1
service nginx restart > /dev/null 2>&1
service httpd restart > /dev/null 2>&1

CURRENTVESION=$(php -v | awk '{print $2}' | head -1)
echo "Installed PHP Version: $CURRENTVESION"