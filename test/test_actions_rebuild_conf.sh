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

#----------------------------------------------------------#
#                 Rebuild configuration                    #
#----------------------------------------------------------#

# Database
cmd="v-rebuild-config-database"
$cmd > $tmpfile 2>&1
echo_result "REBUILD CONFIG: database" "$?" "$tmpfile" "$cmd"

# DNS
cmd="v-rebuild-config-dns"
$cmd > $tmpfile 2>&1
echo_result "REBUILD CONFIG: DNS" "$?" "$tmpfile" "$cmd"

# dovecot
cmd="v-rebuild-config-dovecot"
$cmd > $tmpfile 2>&1
echo_result "REBUILD CONFIG: dovecot" "$?" "$tmpfile" "$cmd"

# exim
cmd="v-rebuild-config-exim"
$cmd > $tmpfile 2>&1
echo_result "REBUILD CONFIG: exim" "$?" "$tmpfile" "$cmd"

# httpd
cmd="v-rebuild-config-httpd"
$cmd > $tmpfile 2>&1
echo_result "REBUILD CONFIG: httpd" "$?" "$tmpfile" "$cmd"

# logrotate
cmd="v-rebuild-config-logrotate"
$cmd > $tmpfile 2>&1
echo_result "REBUILD CONFIG: logrotate" "$?" "$tmpfile" "$cmd"

# nginx
cmd="v-rebuild-config-nginx"
$cmd > $tmpfile 2>&1
echo_result "REBUILD CONFIG: nginx" "$?" "$tmpfile" "$cmd"

exit $OUTPUT