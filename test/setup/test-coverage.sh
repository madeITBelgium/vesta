#!/bin/bash

THISDIR=$(dirname $0)
dropletIpv4=$(cat $THISDIR/ip_address)
PASSWORD=$(cat $THISDIR/password)

ssh -i $THISDIR/sshkey.txt root@$dropletIpv4 "/root/kcov/bin/kcov --merge /root/coverage /root/coverage-test_actions_user /root/coverage-test_actions_cron /root/coverage-test_actions_ip /root/coverage-test_actions_web /root/coverage-test_actions_dns /root/coverage-test_actions_ipv6 /root/coverage-test_actions_web_ipv6 /root/coverage-test_actions_dns_ipv6 /root/coverage-test_actions_rebuild_conf /root/coverage-test_actions_backup /root/coverage-test_actions_delete"
ssh -i $THISDIR/sshkey.txt root@$dropletIpv4 "bash <(curl -s https://codecov.io/bash) -t 263c2f7a-f77f-47cc-8a60-0666ad025a25 -s /root/coverage"
exitcode=$?

exit $exitcode