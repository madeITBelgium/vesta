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

# Create username
user="testu_123"

# Create random tmpfile
tmpfile=$(mktemp -p /tmp )

#----------------------------------------------------------#
#                         WEB                              #
#----------------------------------------------------------#

# Add database
database="we"
database_user="we"
database_pass="test123"
cmd="v-add-database $user $database $database_user $database_pass"
$cmd > $tmpfile 2>&1
echo_result "DB: Adding database $database $database_user $database_pass" "$?" "$tmpfile" "$cmd"


# add long database name (should error)
databaselong="websitewithverylongname"
databaselonguser="websitewithverylongname"
cmd="v-add-database $user $databaselong $databaselonguser $database_pass"
$cmd > $tmpfile 2>&1
if [ "$?" -eq 2 ]; then
    retval=0
else
    retval=1
fi
echo_result "DB: Add database with long database name" "$retval" "$tmpfile" "$cmd"

# Test upgrade MySQL
bash $VESTA/upd/upgrade_mysql.sh

#Add long database name
cmd="v-add-database $user $databaselong $databaselonguser $database_pass"
$cmd > $tmpfile 2>&1
echo_result "DB: Add database with long database name" "$retval" "$tmpfile" "$cmd"

v-list-databases $user

# Add delete database
cmd="v-delete-database $user testu_123_$database"
$cmd > $tmpfile 2>&1
echo_result "DB: Delete database testu_123_$database" "$?" "$tmpfile" "$cmd"

# Add delete database
cmd="v-delete-database $user testu_123_$databaselong"
$cmd > $tmpfile 2>&1
echo_result "DB: Delete database testu_123_$databaselong" "$?" "$tmpfile" "$cmd"


exit $OUTPUT