#!/bin/bash
TOKEN=$1

THISDIR=$(dirname $0)

dropletId=$(cat $THISDIR/dropletId)

result=$(curl -X DELETE -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" "https://api.digitalocean.com/v2/droplets/$dropletId" 2>/dev/null)