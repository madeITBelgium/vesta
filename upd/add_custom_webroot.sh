#!/bin/bash
source /etc/profile.d/vesta.sh
source /usr/local/vesta/func/main.sh

#set Default document root
userlist=$(ls --sort=time $VESTA/data/users/)
for user in $userlist; do
    USER_DATA="$VESTA/data/users/$user"
    
    #UPDATE Web
    conf="$USER_DATA/web.conf"
    while read line ; do
        eval $line
        if [ "$(echo $line | grep 'DOCROOT=')" == "" ]; then
	          sed -i "s/DOMAIN='$DOMAIN' IP='$IP'/DOMAIN='$DOMAIN' IP='$IP' DOCROOT='public_html'/g" "$conf"
        else
            update_object_value 'web' 'DOMAIN' "$DOMAIN" '$DOCROOT' "public_html"
        fi
    done < $conf
    $BIN/v-rebuild-user $user
done

$BIN/v-add-user-notification admin "Custom document root!" "Your vesta installation supports custom document root!"
