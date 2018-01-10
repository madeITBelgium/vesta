#!/bin/bash
#TOKEN=$0
#IMAGE=$1

THISDIR=$(dirname $0)

HOSTNAME="vesta.ci.madeit.be"
REGION="ams3"
SIZE="512mb"
dropletId=78291193

#result=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" -d '{"name":"'$HOSTNAME'","region":"'$REGION'","size":"'$SIZE'","image":"'$IMAGE'","ssh_keys":["35:af:b0:92:27:40:a0:6b:95:a5:b7:11:6e:28:af:d5"],"backups":false,"ipv6":true,"user_data":null,"private_networking":null,"volumes": null,"tags":["CI-vesta-madeit"]}' "https://api.digitalocean.com/v2/droplets")
#echo $result;
#result=""
#dropletId=$(echo [$result] | jq -r '.[].droplet.id')
result=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" -d '{"type":"rebuild","image":"'$IMAGE'"}' "https://api.digitalocean.com/v2/droplets/$dropletId/actions")
dropletId=78291193
dropletActive=false
dropletIpv4=""
dropletIpv6=""

while [ $dropletActive != true ]
do
    result=$(curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" "https://api.digitalocean.com/v2/droplets/$dropletId")
    status=$(echo [$result] | jq -r '.[].droplet.status')
    if [ "$status" = "active" ]; then
        dropletActive=true
        dropletIpv4=$(echo [$result] | jq -r '.[].droplet.networks.v4[].ip_address')
        dropletIpv6=$(echo [$result] | jq -r '.[].droplet.networks.v6[].ip_address')
    else
        sleep 10
    fi
done

ssh-keyscan -H $dropletIpv4 >> ~/.ssh/known_hosts

ssh -i sshkey.txt root@$dropletIpv4 "curl -O http://vestacp.com/pub/vst-install.sh"
ssh -i sshkey.txt root@$dropletIpv4 "bash vst-install.sh --force --nginx yes --apache yes --phpfpm no --named yes --remi yes --vsftpd yes --proftpd no --iptables yes --fail2ban yes --quota no --exim yes --dovecot yes --spamassassin yes --clamav yes --mysql yes --postgresql no --hostname vesta.ci.madeit.be --email info@madeit.be --password admin -y no"

rsync -a ../ username@remote_host:destination_directory

#Add Hosts below 
echo "Host $dropletIpv4" >> ~/.ssh/config
echo "User root" >> ~/.ssh/config
echo "Port 22" >> ~/.ssh/config
echo "IdentityFile $THISDIR/sshkey.txt" >> ~/.ssh/config

rsync --exclude conf --exclude data --exclude log --exclude nginx --exclude php --exclude ssl -e ssh $THISDIR/../ root@$dropletIpv4:/usr/local/vesta


ssh -i sshkey.txt root@$dropletIpv4 "bash /usr/local/vesta/bin/v-restart-service vesta"
ssh -i sshkey.txt root@$dropletIpv4 "bash /usr/local/vesta/test/actions.sh"
exit $?