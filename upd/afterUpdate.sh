#!/bin/bash

source /etc/profile.d/vesta.sh
source /usr/local/vesta/func/main.sh
source /usr/local/vesta/conf/vesta.conf

if [ "$VERSION" = "0.9.8" ]; then
    #Convert to made I.T.
    bash /usr/local/vesta/upd/add_ipv6.sh
    bash /usr/local/vesta/upd/add_plugin.sh
    VERSION="0.0.1"
    sed -i "s/VERSION=.*/VERSION='0.0.1'/g" /usr/local/vesta/conf/vesta.conf
fi

if [ "$VERSION" = "0.0.1" ]; then
    VERSION="0.0.2"
    sed -i "s/VERSION=.*/VERSION='0.0.2'/g" /usr/local/vesta/conf/vesta.conf
fi

if [ "$VERSION" = "0.0.2" ]; then
    VERSION="0.0.3"
    sed -i "s/VERSION=.*/VERSION='0.0.3'/g" /usr/local/vesta/conf/vesta.conf
fi

if [ "$VERSION" = "0.0.3" ]; then
    bash /usr/local/vesta/upd/add_mail_ssl.sh
    VERSION="0.0.4"
    sed -i "s/VERSION=.*/VERSION='0.0.4'/g" /usr/local/vesta/conf/vesta.conf
    
    
    $BIN/v-update-web-templates
    userlist=$(ls --sort=time $VESTA/data/users/)
    for user in $userlist; do
        $BIN/v-rebuild-user $user
    done
fi

if [ "$VERSION" = "0.0.4" ]; then
    bash /usr/local/vesta/upd/add_mail_ssl.sh
    VERSION="0.0.5"
    sed -i "s/VERSION=.*/VERSION='0.0.5'/g" /usr/local/vesta/conf/vesta.conf
    
    bash /usr/local/vesta/upd/separate_web_conf.sh
fi

if [ "$VERSION" = "0.0.5" ]; then
    VERSION="0.0.6"
    sed -i "s/VERSION=.*/VERSION='0.0.6'/g" /usr/local/vesta/conf/vesta.conf
fi

if [ "$VERSION" = "0.0.6" ]; then
    VERSION="0.0.7"
    sed -i "s/VERSION=.*/VERSION='0.0.7'/g" /usr/local/vesta/conf/vesta.conf
fi

if [ "$VERSION" = "0.0.7" ]; then
    VERSION="0.0.8"
    sed -i "s/VERSION=.*/VERSION='0.0.8'/g" /usr/local/vesta/conf/vesta.conf

    #Fix not changed templates
    userlist=$(ls --sort=time $VESTA/data/users/)
    for user in $userlist; do
        $BIN/v-rebuild-web-domains $user
    done
fi

if [ "$VERSION" = "0.0.8" ]; then
    VERSION="0.0.9"
    sed -i "s/VERSION=.*/VERSION='0.0.9'/g" /usr/local/vesta/conf/vesta.conf

    /usr/local/vesta/bin/v-rebuild-config-logrotate
    /usr/local/vesta/bin/v-update-dns-templates
    /usr/local/vesta/bin/v-update-web-templates
    
    userlist=$(ls --sort=time $VESTA/data/users/)
    for user in $userlist; do
        $BIN/v-rebuild-dns-domains $user
        $BIN/v-rebuild-web-domains $user
    done
fi

if [ "$VERSION" = "0.0.9" ]; then
    VERSION="0.0.10"
    sed -i "s/VERSION=.*/VERSION='0.0.10'/g" /usr/local/vesta/conf/vesta.conf
    bash /usr/local/vesta/upd/fix_roundcube.sh
    
    #UPDATE BACKUP HOSTS
    files=$(ls /usr/local/vesta/ | grep backup.conf)
    for file in $files; do
        conf="/usr/local/vesta/$file"
        while read line ; do
            eval $line
            if [ "$(echo $line | grep 'ROTATE=')" == "" ]; then
                sed -i "s/TIME='$TIME' DATE='$DATE'/ROTATE='yes' TIME='$TIME' DATE='$DATE'/g" "$conf"
            fi
        done < $conf
    done
fi

if [ "$VERSION" = "0.0.10" ]; then
    VERSION="0.0.11"
    sed -i "s/VERSION=.*/VERSION='0.0.11'/g" /usr/local/vesta/conf/vesta.conf
fi

if [ "$VERSION" = "0.0.11" ]; then
    VERSION="0.0.12"
    sed -i "s/VERSION=.*/VERSION='0.0.12'/g" /usr/local/vesta/conf/vesta.conf
    
    bash /usr/local/vesta/upd/fix_dhcprenew.sh
    bash /usr/local/vesta/upd/limit_sudo.sh
fi


if [ "$VERSION" = "0.0.12" ]; then
    VERSION="0.0.13"
    sed -i "s/VERSION=.*/VERSION='0.0.13'/g" /usr/local/vesta/conf/vesta.conf
    
    bash /usr/local/vesta/upd/fix_nologinShell.sh
    bash /usr/local/vesta/upd/add_custom_docroot.sh
    bash /usr/local/vesta/upd/fix_httpd_permission.sh
    
    #Disable API by default
    if [ "$(grep 'API=' /usr/local/vesta/conf/vesta.conf)" == "" ]; then
        echo "API='no'" >> /usr/local/vesta/conf/vesta.conf
    fi
    
    #UPDATE BACKUP HOSTS
    files=$(ls /usr/local/vesta/ | grep backup.conf)
    for file in $files; do
        conf="/usr/local/vesta/$file"
        while read line ; do
            eval $line
            if [ "$(echo $line | grep 'ROTATE=')" == "" ]; then
                sed -i "s/TIME='$TIME' DATE='$DATE'/ROTATE='yes' TIME='$TIME' DATE='$DATE'/g" "$conf"
            fi
        done < $conf
    done
fi

if [ "$VERSION" = "0.0.13" ]; then
    VERSION="0.0.14"
    sed -i "s/VERSION=.*/VERSION='0.0.14'/g" /usr/local/vesta/conf/vesta.conf
    
    echo "Run script /usr/local/vesta/bin/v-update-web-templates"
fi

if [ "$VERSION" = "0.0.14" ]; then
    VERSION="0.0.15"
    sed -i "s/VERSION=.*/VERSION='0.0.15'/g" /usr/local/vesta/conf/vesta.conf
    
    echo "Run script /usr/local/vesta/bin/v-update-web-templates"
fi

if [ "$VERSION" = "0.0.15" ]; then
    VERSION="0.0.16"
    sed -i "s/VERSION=.*/VERSION='0.0.16'/g" /usr/local/vesta/conf/vesta.conf
    
    bash /usr/local/vesta/upd/fix_docroot.sh
fi

if [ "$VERSION" = "0.0.16" ]; then
    VERSION="0.0.17"
    #sed -i "s/VERSION=.*/VERSION='0.0.17'/g" /usr/local/vesta/conf/vesta.conf
    
    if [ "$FIREWALL_EXTENSION" = 'fail2ban' ]; then
        bash /usr/local/vesta/bin/v-rebuild-config-fail2ban
    fi
    
    if [ "$PROXY_SYSTEM" = 'nginx' ]; then
        bash /usr/local/vesta/upd/update_nginx_extensions.sh
    fi
fi

bash /usr/local/vesta/upd/add_default_plugins.sh
