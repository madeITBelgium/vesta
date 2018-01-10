#!/bin/bash
source /etc/profile.d/vesta.sh
source /usr/local/vesta/func/main.sh

userlist=$(ls --sort=time $VESTA/data/users/)
for user in $userlist; do
    $BIN/v-rebuild-user $user
done