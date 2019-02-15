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
#                         Cron                             #
#----------------------------------------------------------#

# Add cron job
cmd="v-add-cron-job $user 1 1 1 1 1 echo"
$cmd > $tmpfile 2>&1
echo_result "CRON: Adding cron job" "$?" "$tmpfile" "$cmd"

# Suspend cron job
cmd="v-suspend-cron-job $user 1"
$cmd > $tmpfile 2>&1
echo_result "CRON: Suspending cron job" "$?" "$tmpfile" "$cmd"

# Unsuspend cron job
cmd="v-unsuspend-cron-job $user 1"
$cmd > $tmpfile 2>&1
echo_result "CRON: Unsuspending cron job" "$?" "$tmpfile" "$cmd"

# Delete cron job
cmd="v-delete-cron-job $user 1"
$cmd > $tmpfile 2>&1
echo_result "CRON: Deleting cron job" "$?" "$tmpfile" "$cmd"

# Add cron job
cmd="v-add-cron-job $user 1 1 1 1 1 echo 1"
$cmd > $tmpfile 2>&1
echo_result "CRON: Adding cron job" "$?" "$tmpfile" "$cmd"

# Add cron job
cmd="v-add-cron-job $user 1 1 1 1 1 echo 1"
$cmd > $tmpfile 2>&1
if [ "$?" -eq 4 ]; then
    retval=0
else
    retval=1
fi
echo_result "CRON: Duplicate cron job check" "$retval" "$tmpfile" "$cmd"

# Add second cron job
cmd="v-add-cron-job $user 2 2 2 2 2 echo 2"
$cmd > $tmpfile 2>&1
echo_result "CRON: Adding second cron job" "$?" "$tmpfile" "$cmd"

# Rebuild cron jobs
cmd="v-rebuild-cron-jobs $user"
$cmd > $tmpfile 2>&1
echo_result "CRON: Rebuilding cron jobs" "$?" "$tmpfile" "$cmd"

exit $OUTPUT