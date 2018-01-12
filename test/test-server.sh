#!/bin/bash

THISDIR=$(dirname $0)
dropletIpv4=$(cat $THISDIR/ip_address)
PASSWORD=$(cat $THISDIR/password)

ssh -i $THISDIR/sshkey.txt root@$dropletIpv4 "bash /usr/local/vesta/test/test_actions.sh"
exitcode=$?

ssh -i $THISDIR/sshkey.txt root@$dropletIpv4 "bash /usr/local/vesta/test/test_json_listing.sh"
exitcode2=$?

if [ $exitcode -gt 0 ]; then
    exit $exitcode
fi
exit $exitcode2