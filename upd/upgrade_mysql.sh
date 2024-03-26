#!/bin/bash

CURRENTVESION=$(mysql -V | awk '{print $5}' | cut -d- -f1)

#Get centos version 7, 8 or 9
os=$(cut -f 1 -d ' ' /etc/redhat-release)
release=$(grep -o "[0-9.]*" /etc/redhat-release |head -n1)


if [ "$release" == "7" ]; then
    VERSION="10.11"
    echo "Start upgrading mysql $CURRENTVESION to $VERSION"

    echo "Remove current mysql server"
    yum remove -y mariadb mariadb-server
    yum install -y nano epel-release

    echo "Add MariaDB $VERSION repo settings"

    echo "# MariaDB $VERSION CentOS repository list" > /etc/yum.repos.d/mariadb.repo
    echo "# http://downloads.mariadb.org/mariadb/repositories/" >> /etc/yum.repos.d/mariadb.repo
    echo "[mariadb]" >> /etc/yum.repos.d/mariadb.repo
    echo "name = MariaDB" >> /etc/yum.repos.d/mariadb.repo
    echo "baseurl = http://yum.mariadb.org/$VERSION/centos7-amd64" >> /etc/yum.repos.d/mariadb.repo
    echo "gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB" >> /etc/yum.repos.d/mariadb.repo
    echo "gpgcheck=1" >> /etc/yum.repos.d/mariadb.repo

    echo "Install MariaDB server"
    yum install MariaDB-server MariaDB-client -y

    echo "Start MariaDB services"
    #systemctl enable mysql
    service mysql start 2> /dev/null
    service mariadb start 2> /dev/null

    echo "Upgrade databases"
    mysql_upgrade
fi

# if release 8 or 9
if [ "$release" == "8" ]; then
    VERSION="10.11"
    echo "Start upgrading mysql $CURRENTVESION to $VERSION"

    sudo rpm --import https://supplychain.mariadb.com/MariaDB-Server-GPG-KEY

    echo "Remove current mysql server"
    dnf remove -y mariadb mariadb-server
    dnf install -y nano epel-release

    echo "Add MariaDB $VERSION repo settings"

    echo "# MariaDB $VERSION CentOS repository list" > /etc/yum.repos.d/mariadb.repo
    echo "# http://downloads.mariadb.org/mariadb/repositories/" >> /etc/yum.repos.d/mariadb.repo
    echo "[mariadb]" >> /etc/yum.repos.d/mariadb.repo
    echo "name = MariaDB" >> /etc/yum.repos.d/mariadb.repo
    echo "baseurl = http://yum.mariadb.org/$VERSION/centos8-amd64" >> /etc/yum.repos.d/mariadb.repo
    echo "gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB" >> /etc/yum.repos.d/mariadb.repo
    echo "gpgcheck=1" >> /etc/yum.repos.d/mariadb.repo

    echo "Install MariaDB server"
    dnf install MariaDB-server MariaDB-client -y

    echo "Start MariaDB services"
    systemctl enable mysql
    systemctl start mysql

    echo "Upgrade databases"
    mysql_upgrade
fi

if [ "$release" == "9" ]; then
    VERSION="11.5"
    echo "Start upgrading mysql $CURRENTVESION to $VERSION"

    sudo rpm --import https://supplychain.mariadb.com/MariaDB-Server-GPG-KEY

    echo "Remove current mysql server"
    dnf remove -y mariadb mariadb-server
    dnf install -y nano epel-release

    echo "Add MariaDB $VERSION repo settings"

    echo "# MariaDB $VERSION CentOS repository list" > /etc/yum.repos.d/mariadb.repo
    echo "# http://downloads.mariadb.org/mariadb/repositories/" >> /etc/yum.repos.d/mariadb.repo
    echo "[mariadb]" >> /etc/yum.repos.d/mariadb.repo
    echo "name = MariaDB" >> /etc/yum.repos.d/mariadb.repo
    echo "baseurl = http://yum.mariadb.org/$VERSION/centos9-amd64" >> /etc/yum.repos.d/mariadb.repo
    echo "gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB" >> /etc/yum.repos.d/mariadb.repo
    echo "gpgcheck=1" >> /etc/yum.repos.d/mariadb.repo

    echo "Install MariaDB server"
    dnf install MariaDB-server MariaDB-client -y

    echo "Start MariaDB services"
    systemctl enable mysql
    systemctl start mysql

    echo "Upgrade databases"
    mysql_upgrade
fi

echo "Database upgraded to $(mysql -V | awk '{print $5}' | cut -d- -f1)"
