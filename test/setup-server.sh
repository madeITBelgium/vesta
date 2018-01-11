#!/bin/bash
#TOKEN=$0
#IMAGE=$1

generate_password() {
    matrix=0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz
    lenght=10
    i=1
    while [ $i -le $lenght ]; do
        pass="$pass${matrix:$(($RANDOM%${#matrix})):1}"
       ((i++))
    done
    echo "$pass"
}

rPassword=$(generate_password)
echo $rPassword
THISDIR=$(dirname $0)

HOSTNAME="vesta.ci.madeit.be"
REGION="ams3"
SIZE="512mb"

if [ "$1" = "" ]; then
    TOKEN=""
    IMAGE="ubuntu-14-04-x64"
fi

#dropletId=78416344
if [ -z ${dropletId} ]; then
    result=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" -d '{"name":"'$HOSTNAME'","region":"'$REGION'","size":"'$SIZE'","image":"'$IMAGE'","ssh_keys":["35:af:b0:92:27:40:a0:6b:95:a5:b7:11:6e:28:af:d5"],"backups":false,"ipv6":true,"user_data":null,"private_networking":null,"volumes": null,"tags":["CI-vesta-madeit"]}' "https://api.digitalocean.com/v2/droplets" 2>/dev/null)
    dropletId=$(echo [$result] | jq -r '.[].droplet.id')
    if [ "$dropletId" = "null" ]; then
        echo $result;
        exit 1;
    fi
fi
echo $dropletId > $THISDIR/dropletId
dropletActive=false
dropletIpv4=""
dropletIpv6=""

#exit 
while [ $dropletActive != true ]
do
    result=$(curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" "https://api.digitalocean.com/v2/droplets/$dropletId" 2>/dev/null)
    status=$(echo [$result] | jq -r '.[].droplet.status')
    echo $status
    if [ "$status" = "null" ]; then
        echo $result;
        exit 1;
    fi
    if [ "$status" = "active" ]; then
        dropletActive=true
        dropletIpv4=$(echo [$result] | jq -r '.[].droplet.networks.v4[].ip_address')
        dropletIpv6=$(echo [$result] | jq -r '.[].droplet.networks.v6[].ip_address')
        sleep 30
    else
        sleep 10
    fi
done

echo "Add ssh key"
ssh-keyscan -H $dropletIpv4 >> ~/.ssh/known_hosts

echo "Install VestaCP by Made I.T."
ssh -i $THISDIR/sshkey.txt root@$dropletIpv4 "curl -O http://cp.madeit.be/vst-install.sh"
ssh -i $THISDIR/sshkey.txt root@$dropletIpv4 "bash vst-install.sh --force --nginx yes --apache yes --phpfpm no --named yes --remi yes --vsftpd yes --proftpd no --iptables yes --fail2ban yes --quota no --exim yes --dovecot yes --spamassassin yes --clamav yes --mysql yes --postgresql no --hostname vesta.ci.madeit.be --email info@madeit.be --password admin -y no"

#Add Hosts below 
echo "Change password"
ssh -i $THISDIR/sshkey.txt root@$dropletIpv4 'echo "root:'$rPassword'" | /usr/sbin/chpasswd'

echo "Rsync"
sshpass -p $rPassword rsync -azP --exclude .git --exclude conf --exclude data --exclude log --exclude nginx --exclude php --exclude ssl $THISDIR/../ root@$dropletIpv4:/usr/local/vesta
sshpass -p $rPassword rsync -azP $THISDIR/../test/ root@$dropletIpv4:/usr/local/vesta/test

echo "Execute testing"
ssh -i $THISDIR/sshkey.txt root@$dropletIpv4 "source /etc/profile.d/vesta.sh"
ssh -i $THISDIR/sshkey.txt root@$dropletIpv4 "bash /usr/local/vesta/bin/v-restart-service vesta"
ssh -i $THISDIR/sshkey.txt root@$dropletIpv4 "bash /usr/local/vesta/upd/add_plugin.sh"
ssh -i $THISDIR/sshkey.txt root@$dropletIpv4 "bash /usr/local/vesta/upd/afterUpdate.sh"
ssh -i $THISDIR/sshkey.txt root@$dropletIpv4 "bash /usr/local/vesta/test/test_actions.sh"
exitcode=$?

echo $rPassword
exit $exitcode