#!/bin/bash
source /etc/profile.d/vesta.sh
source /usr/local/vesta/func/main.sh

userlist=$(ls --sort=time $VESTA/data/users/)
for user in $userlist; do
    USER_DATA="$VESTA/data/users/$user"
    
    #FIX Web conf
    conf="$USER_DATA/web.conf"
    while read line ; do
        eval $line
        #Check documentroot
        if [ -z "$DOCROOT" ]; then
            update_object_value 'web' 'DOMAIN' "$DOMAIN" '$DOCROOT' "public_html"
        fi
    done < $conf
    $BIN/v-rebuild-user $user
done

$BIN/v-add-user-notification admin "Docroot is fixed!" "Your docroot are fixed!"
