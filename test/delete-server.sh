#!/bin/bash
TOKEN=$1
THISDIR=$(dirname $0)
dropletId=$(cat $THISDIR/dropletId)

if [ "$1" = "" ]; then
    TOKEN=$(cat $THISDIR/token)
fi

result=$(curl -X DELETE -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" "https://api.digitalocean.com/v2/droplets/$dropletId" 2>/dev/null)
echo $result