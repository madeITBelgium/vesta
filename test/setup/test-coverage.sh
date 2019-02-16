#!/bin/bash

THISDIR=$(dirname $0)
dropletIpv4=$(cat $THISDIR/ip_address)
PASSWORD=$(cat $THISDIR/password)

cd $THISDIR
cd ../..
BRANCH=$(git branch | grep \* | cut -d ' ' -f2)
COMMIT=$(git log --format="%H" -n 1)

ssh -i $THISDIR/sshkey.txt root@$dropletIpv4 "/root/kcov/bin/kcov --merge /usr/local/vesta/coverage /usr/local/vesta/coverage-test_actions_user /usr/local/vesta/coverage-test_actions_cron /usr/local/vesta/coverage-test_actions_ip /usr/local/vesta/coverage-test_actions_web /usr/local/vesta/coverage-test_actions_dns /usr/local/vesta/coverage-test_actions_ipv6 /usr/local/vesta/coverage-test_actions_web_ipv6 /usr/local/vesta/coverage-test_actions_dns_ipv6 /usr/local/vesta/coverage-test_actions_rebuild_conf /usr/local/vesta/coverage-test_actions_backup /usr/local/vesta/coverage-test_actions_delete"
ssh -i $THISDIR/sshkey.txt root@$dropletIpv4 "bash <(curl -s https://codecov.io/bash) -t 263c2f7a-f77f-47cc-8a60-0666ad025a25 -s /usr/local/vesta/coverage -C $COMMIT"
exitcode=$?

exit $exitcode