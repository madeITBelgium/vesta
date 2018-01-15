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

#----------------------------------------------------------#
#                          IPv6                            #
#----------------------------------------------------------#

# Add ipv6 address
cmd="v-add-sys-ipv6 2001:1620:28:1:b6f:8bca:93:a116 64 $interface $user"
$cmd > $tmpfile 2>&1
echo_result "IP6: Adding ipv6 2001:1620:28:1:b6f:8bca:93:a116" "$?" "$tmpfile" "$cmd"
#/usr/nginx/sbin/nginx -t -c /etc/nginx/nginx.conf
# Add duplicate ipv6
$cmd > $tmpfile 2>&1
if [ "$?" -eq 4 ]; then
    retval=0
else
    retval=1
fi
echo_result "IP: Duplicate ip address check" "$retval" "$tmpfile" "$cmd"

# Delete ip address
cmd="v-delete-sys-ipv6 2001:1620:28:1:b6f:8bca:93:a116"
$cmd > $tmpfile 2>&1
echo_result "IP6: Deleting ip 2001:1620:28:1:b6f:8bca:93:a116" "$?" "$tmpfile" "$cmd"

# Add ip address
cmd="v-add-sys-ipv6 2001:1620:28:1:b6f:8bca:93:a111 64 $interface $user"
$cmd > $tmpfile 2>&1
echo_result "IP6: Adding ip 2001:1620:28:1:b6f:8bca:93:a111" "$?" "$tmpfile" "$cmd"

cmd="v-add-sys-ipv6 2001:1620:28:1:b6f:8bca:93:a112 64 $interface $user"
$cmd > $tmpfile 2>&1
echo_result "IP6: Adding ip 2001:1620:28:1:b6f:8bca:93:a112" "$?" "$tmpfile" "$cmd"


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


#----------------------------------------------------------#
#                         DNS                              #
#----------------------------------------------------------#

# Add dns domain
cmd="v-add-dns-domain $user $domain 198.18.0.125 2001:1620:28:1:b6f:8bca:93:a111"
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
cmd="v-add-dns-record $user $domain test AAAA 2001:1620:28:1:b6f:8bca:93:a111 \"\" 25"
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
cmd="v-delete-dns-record $user $domain 25"
$cmd > $tmpfile 2>&1
echo_result "DNS: Deleteing dns domain record" "$?" "$tmpfile" "$cmd"

# Change exp
cmd="v-change-dns-domain-exp $user $domain 2020-01-01"
$cmd > $tmpfile 2>&1
echo_result "DNS: Changing expiriation date" "$?" "$tmpfile" "$cmd"

# Change ip
cmd="v-change-dns-domain-ipv6 $user $domain 2001:1620:28:1:b6f:8bca:93:a112"
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