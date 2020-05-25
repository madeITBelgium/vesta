#!/bin/bash

if [ ! -e "/etc/profile.d/vesta.sh" ]; then
    echo "export VESTA='$VESTA'" > /etc/profile.d/vesta.sh
    chmod 755 /etc/profile.d/vesta.sh
    source /etc/profile.d/vesta.sh
    PATH=$PATH:$VESTA/bin
    export PATH
fi

source /etc/profile.d/vesta.sh
source /usr/local/vesta/func/main.sh
bash /usr/local/vesta/upd/add_plugin.sh

if [ -z "$(grep "v-notify-sys-status" $VESTA/data/users/admin/cron.conf)" ]; then
    command="sudo $VESTA/bin/v-notify-sys-status > /dev/null"
    
    min=$(generate_password '012345' '2')
    hour=$(generate_password '1234567' '1')
    $VESTA/bin/v-add-cron-job 'admin' "$min" "$hour" '*' '*' '*' "$command" 
fi

$VESTA/bin/v-add-cron-vesta-autoupdate