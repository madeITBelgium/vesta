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

# Add web domain
domain="test-abcd.example.com"
cmd="v-add-web-domain $user $domain 198.18.0.125 2001:1620:28:1:b6f:8bca:93:a111"
$cmd > $tmpfile 2>&1
echo_result "WEB: Adding domain $domain on 2001:1620:28:1:b6f:8bca:93:a111" "$?" "$tmpfile" "$cmd"

# Add duplicate
$cmd > $tmpfile 2>&1
if [ "$?" -eq 4 ]; then
    retval=0
else
    retval=1
fi
echo_result "WEB: Duplicate web domain check" "$retval" "$tmpfile" "$cmd"

# Add web domain alias
cmd="v-add-web-domain-alias $user $domain v3.$domain"
$cmd > $tmpfile 2>&1
echo_result "WEB: Adding alias v3.$domain" "$?" "$tmpfile" "$cmd"

# Alias duplicate
$cmd > $tmpfile 2>&1
if [ "$?" -eq 4 ]; then
    retval=0
else
    retval=1
fi
echo_result "WEB: Duplicate web alias check" "$retval" "$tmpfile" "$cmd"

# Add web domain stats
cmd="v-add-web-domain-stats $user $domain webalizer"
$cmd > $tmpfile 2>&1
echo_result "WEB: Enabling webalizer" "$?" "$tmpfile" "$cmd"

# Add web domain stats 
cmd="v-add-web-domain-stats-user $user $domain test m3g4p4ssw0rd"
$cmd > $tmpfile 2>&1
echo_result "WEB: Adding webalizer uzer" "$?" "$tmpfile" "$cmd"

# Suspend web domain
cmd="v-suspend-web-domain $user $domain"
$cmd > $tmpfile 2>&1
echo_result "WEB: Suspending web domain" "$?" "$tmpfile" "$cmd"

# Unsuspend web domain
cmd="v-unsuspend-web-domain $user $domain"
$cmd > $tmpfile 2>&1
echo_result "WEB: Unsuspending web domain" "$?" "$tmpfile" "$cmd"

# Add web domain ssl
cp $V_TEST/ssl/crt /tmp/$domain.crt
cp $V_TEST/ssl/key /tmp/$domain.key
cmd="v-add-web-domain-ssl $user $domain /tmp"
$cmd > $tmpfile 2>&1
echo_result "WEB: Adding ssl support" "$?" "$tmpfile" "$cmd"

# Rebuild web domains
cmd="v-rebuild-web-domains $user"
$cmd > $tmpfile 2>&1
echo_result "WEB: rebuilding web domains" "$?" "$tmpfile" "$cmd"

exit $OUTPUT