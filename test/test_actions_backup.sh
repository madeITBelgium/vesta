#!/bin/bash

# Define some variables
source /etc/profile.d/vesta.sh

export PATH=$PATH:/usr/local/vesta/bin

V_BIN="$VESTA/bin"
V_TEST="$VESTA/test"

OUTPUT=0

# Define functions
echo_result() {
    echo -ne  "$1"
    #echo -en '\033[60G'
    echo -n '['

    if [ "$2" -ne 0 ]; then
        echo -n 'FAILED'
        echo -n ']'
        echo -ne '\r\n'
        echo ">>> $4"
        echo ">>> RETURN VALUE $2"
        cat $3
    else
        echo -n '  OK  '
        echo -n ']'
    fi
    echo -ne '\r\n'
    
    if [ "$2" -ne 0 ]; then
        OUTPUT=1
    fi
}

# Create random tmpfile
tmpfile=$(mktemp -p /tmp )

#----------------------------------------------------------#
#                 Rebuild configuration                    #
#----------------------------------------------------------#

# Backup all users
cmd="v-backup-users"
$cmd > $tmpfile 2>&1
echo_result "BACKUP USERS: database" "$?" "$tmpfile" "$cmd"

# Backup single user
cmd="v-add-user testbckp testbckp testbckp@example.com default Super Test"
$cmd > $tmpfile 2>&1
echo_result "USER: Adding new user testbckp" "$?" "$tmpfile" "$cmd"

domain="test-testbckp.example.com"
cmd="v-add-web-domain testbckp $domain"
$cmd > $tmpfile 2>&1
echo_result "WEB: Adding domain $domain" "$?" "$tmpfile" "$cmd"

cmd="v-backup-user testbckp"
$cmd > $tmpfile 2>&1
echo_result "BACKUP USER: testbckp" "$?" "$tmpfile" "$cmd"

cmd="v-delete-user testbckp"
$cmd > $tmpfile 2>&1
echo_result "Deleting user testbckp" "$?" "$tmpfile" "$cmd"

# restore user
cmd="v-restore-user testbckp $(ls /backup | grep testbckp)"
$cmd > $tmpfile 2>&1
echo_result "RESTORE USER: testbkcp" "$?" "$tmpfile" "$cmd"

cmd="v-delete-user testbckp"
$cmd > $tmpfile 2>&1
echo_result "Deleting user testbckp" "$?" "$tmpfile" "$cmd"


# restore under different username
mv /backup/$(ls /backup | grep testbckp) /backup/testbackup.2018-07-09_09-34-53.tar
cmd="v-restore-user testbackup testbackup.2018-07-09_09-34-53.tar"
$cmd > $tmpfile 2>&1
echo_result "RESTORE BACKUP: testbckp as user testbackup" "$?" "$tmpfile" "$cmd"

cmd="v-delete-user testbackup"
$cmd > $tmpfile 2>&1
echo_result "Deleting user testbckp" "$?" "$tmpfile" "$cmd"

rm $tmpfile

exit $OUTPUT