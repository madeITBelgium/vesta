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
#                         User                             #
#----------------------------------------------------------#
# Add user
cmd="v-add-user $user $user $user@example.com default Super Test"
$cmd > $tmpfile 2>&1
echo_result "USER: Adding new user $user" "$?" "$tmpfile" "$cmd"

# Change user password
cmd="v-change-user-password $user t3st_p4ssw0rd"
$cmd > $tmpfile 2>&1
echo_result "USER: Changing password" "$?" "$tmpfile" "$cmd"

# Change user contact
cmd="v-change-user-contact $user tester@example.com"
$cmd > $tmpfile 2>&1
echo_result "USER: Changing email" "$?" "$tmpfile" "$cmd"

# Change system shell
cmd="v-change-user-shell $user bash"
$cmd > $tmpfile 2>&1
echo_result "USER: Changing system shell to /bin/bash" "$?" "$tmpfile" "$cmd"

# Change name servers
cmd="v-change-user-ns $user ns0.com ns1.com ns2.com ns3.com"
$cmd > $tmpfile 2>&1
echo_result "USER: Changing nameservers" "$?" "$tmpfile" "$cmd"

exit $OUTPUT