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
#                          IP                              #
#----------------------------------------------------------#

# List network interfaces
cmd="v-list-sys-interfaces plain"
interface=$($cmd 2> $tmpfile | head -n 1)
if [ -z "$interface" ]; then
    echo_result "IP: Listing network interfaces" "1" "$tmpfile" "$cmd"
else
    echo_result "IP: Listing network interfaces" "0" "$tmpfile" "$cmd"
fi

# Add ip address
cmd="v-add-sys-ip 198.18.0.123 255.255.255.255 $interface $user"
$cmd > $tmpfile 2>&1
echo_result "IP: Adding ip 198.18.0.123" "$?" "$tmpfile" "$cmd"
/usr/sbin/nginx -t -c /etc/nginx/nginx.conf
# Add duplicate ip
$cmd > $tmpfile 2>&1
if [ "$?" -eq 4 ]; then
    retval=0
else
    retval=1
fi
echo_result "IP: Duplicate ip address check" "$retval" "$tmpfile" "$cmd"

# Delete ip address
cmd="v-delete-sys-ip 198.18.0.123"
$cmd > $tmpfile 2>&1
echo_result "IP: Deleting ip 198.18.0.123" "$?" "$tmpfile" "$cmd"

# Add ip address
cmd="v-add-sys-ip 198.18.0.125 255.255.255.255 $interface $user"
$cmd > $tmpfile 2>&1
echo_result "IP: Adding ip 198.18.0.125" "$?" "$tmpfile" "$cmd"

# Add ip address
cmd="v-add-sys-ip 198.18.0.126 255.255.255.255 $interface"
$cmd > $tmpfile 2>&1
echo_result "IP: Adding ip 198.18.0.126" "$?" "$tmpfile" "$cmd"

exit $OUTPUT