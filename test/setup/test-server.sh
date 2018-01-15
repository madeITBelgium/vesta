#!/bin/bash

THISDIR=$(dirname $0)
dropletIpv4=$(cat $THISDIR/ip_address)
PASSWORD=$(cat $THISDIR/password)

ssh -i $THISDIR/sshkey.txt root@$dropletIpv4 "ls -la /usr/local/vesta"
ssh -i $THISDIR/sshkey.txt root@$dropletIpv4 "ls -la /usr/local/vesta/test"
ssh -i $THISDIR/sshkey.txt root@$dropletIpv4 "bash /usr/local/vesta/test/$1.sh"
exitcode=$?

exit $exitcode