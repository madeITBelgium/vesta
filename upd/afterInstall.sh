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

bash /usr/local/vesta/upd/fix_httpd_permission.sh
