#!/bin/bash

THISDIR=$(dirname $0)
dropletIpv4=$(cat $THISDIR/ip_address)
PASSWORD=$(cat $THISDIR/password)

ssh -i $THISDIR/sshkey.txt root@$dropletIpv4 "/root/kcov/bin/kcov --include-path=/usr/local/vesta/bin /root/coverage-$1 /usr/local/vesta/test/$1.sh"
exitcode=$?

exit $exitcode