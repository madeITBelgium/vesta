#!/bin/bash
TOKEN=$1
IMAGE=$2

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
THISDIR=$(dirname $0)

HOSTNAME="vesta.ci.madeit.be"
REGION="ams3"
SIZE="512mb"

if [ "$1" = "" ]; then
    TOKEN=$(cat $THISDIR/token)
    IMAGE="centos-7-x64"
fi

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

chmod 600 $THISDIR/sshkey.txt
ssh-keyscan -H $dropletIpv4 >> ~/.ssh/known_hosts

echo "Host $dropletIpv4" >> ~/.ssh/config
echo "User root" >> ~/.ssh/config
echo "Port 22" >> ~/.ssh/config
echo "IdentityFile $THISDIR/sshkey.txt" >> ~/.ssh/config
 
echo "Install VestaCP by Made I.T."
ssh -i $THISDIR/sshkey.txt root@$dropletIpv4 "curl -O http://cp.madeit.be/vst-install-rhel.sh"
ssh -i $THISDIR/sshkey.txt root@$dropletIpv4 "bash vst-install-rhel.sh -s vesta.ci.madeit.be -e info@madeit.be -p admin -y no -f"

#Add Hosts below 
ssh -i $THISDIR/sshkey.txt root@$dropletIpv4 "echo \"root:$rPassword\" | /usr/sbin/chpasswd"

sshpass -p $rPassword rsync -azP --exclude conf --exclude data --exclude log --exclude nginx --exclude php --exclude ssl $THISDIR/../../ root@$dropletIpv4:/usr/local/vesta
sshpass -p $rPassword rsync -azP $THISDIR/../ root@$dropletIpv4:/usr/local/vesta/test

sshpass -p $rPassword ssh root@$dropletIpv4 "source ~/.bash_profile"
sshpass -p $rPassword ssh root@$dropletIpv4 "source /etc/profile.d/vesta.sh"
sshpass -p $rPassword ssh root@$dropletIpv4 "bash /usr/local/vesta/bin/v-restart-service vesta"
sshpass -p $rPassword ssh root@$dropletIpv4 "bash /usr/local/vesta/upd/afterInstall.sh"
sshpass -p $rPassword ssh root@$dropletIpv4 "bash /usr/local/vesta/upd/afterUpdate.sh"

echo $rPassword > $THISDIR/password
echo $dropletIpv4 > $THISDIR/ip_address


#setup coverage
sshpass -p $rPassword ssh root@$dropletIpv4 "yum install -y gcc-c++ cmake elfutils-libelf-devel libcurl-devel binutils-devel elfutils-devel"
sshpass -p $rPassword ssh root@$dropletIpv4 "cd /root && wget https://github.com/SimonKagstrom/kcov/archive/master.tar.gz && tar xzf master.tar.gz"
sshpass -p $rPassword ssh root@$dropletIpv4 "cd /root/kcov-master && mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX=/root/kcov .. && make && make install"
