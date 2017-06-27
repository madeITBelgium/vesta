#!/bin/bash

# Define some variables
source /etc/profile.d/vesta.sh

export PATH=$PATH:/usr/local/vesta/bin

V_BIN="$VESTA/bin"
V_TEST="$VESTA/test"

OUTPUT=0

# Define functions
random() {
    MATRIX='0123456789'
    LENGTH=$1
    while [ ${n:=1} -le $LENGTH ]; do
        rand="$rand${MATRIX:$(($RANDOM%${#MATRIX})):1}"
        let n+=1
    done
    echo "$rand"
}

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

# Create random username
user="testu_$(random 4)"
while [ ! -z "$(grep "^$user:" /etc/passwd)" ]; do
    user="tmp_$(random 4)"
done

# Create random tmpfile
tmpfile=$(mktemp -p /tmp )


#----------------------------------------------------------#
#                         User                             #
#----------------------------------------------------------#
# Add user
testAddUser() {
    cmd="v-add-user $user $user $user@vestacp.com default Super Test"
    $cmd > $tmpfile 2>&1
    assertTrue "USER: Adding new user $user >> $cmd >>> $(cat $tmpfile)" "[$? -eq 0]"
}

testChangePassword() {
    cmd="v-change-user-password $user t3st_p4ssw0rd"
    $cmd > $tmpfile 2>&1
    assertTrue "USER: Changing password >> $cmd >>> $(cat $tmpfile)" "[$? -eq 0]"
}

testChangeContact() {
    cmd="v-change-user-contact $user tester@vestacp.com"
    $cmd > $tmpfile 2>&1
    assertTrue "USER: Changing email >> $cmd >>> $(cat $tmpfile)" "[$? -eq 0]"
}

testChangeSystemShell() {
    cmd="v-change-user-shell $user bash"
    $cmd > $tmpfile 2>&1
    assertTrue "USER: Changing system shell to /bin/bash >> $cmd >>> $(cat $tmpfile)" "[$? -eq 0]"
}

testChangeNameServers() {
    cmd="v-change-user-ns $user ns0.com ns1.com ns2.com ns3.com"
    $cmd > $tmpfile 2>&1
    assertTrue "USER: Changing nameservers >> $cmd >>> $(cat $tmpfile)" "[$? -eq 0]"
}



# load and run shUnit2
BASE_DIR="`dirname $0`"
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. $BASE_DIR/../bin/shunit2/src/shunit2