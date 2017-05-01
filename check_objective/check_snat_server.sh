#!/bin/bash

# Author: Olari Pipenberg. 

NSPACE="eth3_ns"
DEV="eth3"
SNAT_IP="30.0.127.3"
WEBSERVER_ADDR="30.0.127.1/api.php"
GW="192.168.88.254"

# add default gw
ip netns exec $NSPACE ip route add default via $GW

EXT_IP=$(ip netns exec $NSPACE curl -s --max-time 1  $WEBSERVER_ADDR | jq -r '.ip')
if [[ $EXT_IP == $SNAT_IP ]]; then
	echo "snat for $SNAT_IP is configured"
	# delete default gw
	ip netns exec $NSPACE ip route del default via $GW
	exit 0
fi

echo "snat for $SNAT_IP is not configured"

# delete default gw
ip netns exec $NSPACE ip route del default via $GW

exit 1
