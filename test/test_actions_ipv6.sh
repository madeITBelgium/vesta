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
#                          IPv6                            #
#----------------------------------------------------------#

# List network interfaces
cmd="v-list-sys-interfaces plain"
interface=$($cmd 2> $tmpfile | head -n 1)
if [ -z "$interface" ]; then
    echo_result "IP: Listing network interfaces" "1" "$tmpfile" "$cmd"
else
    echo_result "IP: Listing network interfaces" "0" "$tmpfile" "$cmd"
fi

cmd="v-add-sys-ipv6 2001:1620:28:1:b6f:8bca:93:a112 64 $interface $user"
$cmd > $tmpfile 2>&1
echo_result "IP6: Adding ip 2001:1620:28:1:b6f:8bca:93:a112" "$?" "$tmpfile" "$cmd"


# Add ipv6 address
cmd="v-add-sys-ipv6 2001:1620:28:1:b6f:8bca:93:a116 64 $interface $user"
$cmd > $tmpfile 2>&1
echo_result "IP6: Adding ipv6 2001:1620:28:1:b6f:8bca:93:a116" "$?" "$tmpfile" "$cmd"

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

exit $OUTPUT