#!/bin/bash

CURRENTVESION=$(php -v | awk '{print $2}' | head -1)
echo "Current PHP Version: $CURRENTVESION"

yum-config-manager --disable remi-php71 > /dev/null
yum-config-manager --disable remi-php72 > /dev/null
yum-config-manager --disable remi-php73 > /dev/null
yum-config-manager --enable remi-php74 > /dev/null
yum update -y php > /dev/null

service httpd restart

CURRENTVESION=$(php -v | awk '{print $2}' | head -1)
echo "Installed PHP Version: $CURRENTVESION"