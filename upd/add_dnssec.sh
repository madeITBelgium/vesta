#!/bin/bash

source /etc/profile.d/vesta.sh
source /usr/local/vesta/func/main.sh

#Update per user
userlist=$(ls --sort=time $VESTA/data/users/)
for user in $userlist; do
    USER_DATA="$VESTA/data/users/$user"
    
    #UPDATE mail
    conf="$USER_DATA/dns.conf"
    while read line ; do
        eval $line
        
        add_object_key "dns" 'DOMAIN' "$DOMAIN" 'DNSSEC' 'SUSPENDED'
        update_object_value 'dns' 'DOMAIN' "$DOMAIN" '$DNSSEC' 'no'
    done < $conf
done

