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
#                         Rebuild & Delete                 #
#----------------------------------------------------------#

# Suspend dns domain
domain="test-123.example.com"
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
domain="test-123mail.example.com"
cmd="v-add-mail-domain $user $domain"
$cmd > $tmpfile 2>&1
echo_result "Adding mail domain $domain" "$?" "$tmpfile" "$cmd"

# Rebuild user configs
cmd="v-rebuild-user $user yes"
$cmd > $tmpfile 2>&1
echo_result "Rebuilding user config" "$?" "$tmpfile" "$cmd"

# Delete user
cmd="v-delete-user $user"
$cmd > $tmpfile 2>&1
echo_result "Deleting user $user" "$?" "$tmpfile" "$cmd"

# Delete ip address
cmd="v-delete-sys-ipv6 2001:1620:28:1:b6f:8bca:93:a111"
$cmd > $tmpfile 2>&1
echo_result "Deleting ip 2001:1620:28:1:b6f:8bca:93:a111" "$?" "$tmpfile" "$cmd"

# Delete ip address
cmd="v-delete-sys-ipv6 2001:1620:28:1:b6f:8bca:93:a112"
$cmd > $tmpfile 2>&1
echo_result "Deleting ip 2001:1620:28:1:b6f:8bca:93:a112" "$?" "$tmpfile" "$cmd"

exit $OUTPUT