#!/bin/bash

CURRENTVESION=$(mysql -V | awk '{print $5}' | cut -d- -f1)
VERSION="10.4"

echo "Start upgrading mysql $CURRENTVESION to $VERSION"

echo "Remove current mysql server"
yum remove -y mariadb mariadb-server
yum install -y nano epel-release

echo "Add MariaDB $VERSION repo settings"

echo "# MariaDB 10.4 CentOS repository list" > /etc/yum.repos.d/mariadb.repo
echo "# http://downloads.mariadb.org/mariadb/repositories/" >> /etc/yum.repos.d/mariadb.repo
echo "[mariadb]" >> /etc/yum.repos.d/mariadb.repo
echo "name = MariaDB" >> /etc/yum.repos.d/mariadb.repo
echo "baseurl = http://yum.mariadb.org/10.4/centos7-amd64" >> /etc/yum.repos.d/mariadb.repo
echo "gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB" >> /etc/yum.repos.d/mariadb.repo
echo "gpgcheck=1" >> /etc/yum.repos.d/mariadb.repo

echo "Install MariaDB server"
yum install MariaDB-server MariaDB-client -y

echo "Start MariaDB services"
systemctl enable mysql
service mysql start

echo "Upgrade databases"
mysql_upgrade