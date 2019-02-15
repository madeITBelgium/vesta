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
#                         DNS                              #
#----------------------------------------------------------#

# Add dns domain
domain="test-123.example.com"
cmd="v-add-dns-domain $user $domain 198.18.0.125"
$cmd > $tmpfile 2>&1
echo_result "DNS: Adding dns domain $domain" "$?" "$tmpfile" "$cmd"

# Add duplicate
$cmd > $tmpfile 2>&1
if [ "$?" -eq 4 ]; then
    retval=0
else
    retval=1
fi
echo_result "DNS: Duplicate domain check" "$retval" "$tmpfile" "$cmd"

# Add dns domain record
cmd="v-add-dns-record $user $domain test A \"198.18.0.125\" \"\" 20"
$cmd > $tmpfile 2>&1
echo_result "DNS: Adding dns record" "$?" "$tmpfile" "$cmd"

# Add duplicate
$cmd > $tmpfile 2>&1
if [ "$?" -eq 4 ]; then
    retval=0
else
    retval=1
fi
echo_result "DNS: Duplicate record check" "$retval" "$tmpfile" "$cmd"

# Delete dns domain record
cmd="v-delete-dns-record $user $domain 20"
$cmd > $tmpfile 2>&1
echo_result "DNS: Deleteing dns domain record" "$?" "$tmpfile" "$cmd"

# Change exp
cmd="v-change-dns-domain-exp $user $domain 2020-01-01"
$cmd > $tmpfile 2>&1
echo_result "DNS: Changing expiriation date" "$?" "$tmpfile" "$cmd"

# Change ip
cmd="v-change-dns-domain-ip $user $domain 198.18.0.126"
$cmd > $tmpfile 2>&1
echo_result "DNS: Changing domain ip" "$?" "$tmpfile" "$cmd"

# Suspend dns domain
cmd="v-suspend-dns-domain $user $domain"
$cmd > $tmpfile 2>&1
echo_result "DNS: Suspending domain" "$?" "$tmpfile" "$cmd"

# Unuspend dns domain
cmd="v-unsuspend-dns-domain $user $domain"
$cmd > $tmpfile 2>&1
echo_result "DNS: Unsuspending domain" "$?" "$tmpfile" "$cmd"

# Rebuild dns domain
cmd="v-rebuild-dns-domains $user"
$cmd > $tmpfile 2>&1
echo_result "DNS: Rebuilding domain" "$?" "$tmpfile" "$cmd"


# Add mail domain
cmd="v-add-mail-domain $user $domain"
$cmd > $tmpfile 2>&1
echo_result "Adding mail domain $domain" "$?" "$tmpfile" "$cmd"

# Add mysql database
database=d123
cmd="v-add-database $user $database $database dbp4ssw0rd mysql"
$cmd > $tmpfile 2>&1
echo_result "Adding mysql database $database" "$?" "$tmpfile" "$cmd"

# Add pgsql database
#database=d123
#cmd="v-add-database $user $database $database dbp4ssw0rd pgsql"
#$cmd > $tmpfile 2>&1
#echo_result "Adding pgsql database $database" "$?" "$tmpfile" "$cmd"

# Rebuild user configs
cmd="v-rebuild-user $user yes"
$cmd > $tmpfile 2>&1
echo_result "Rebuilding user config" "$?" "$tmpfile" "$cmd"

exit $OUTPUT