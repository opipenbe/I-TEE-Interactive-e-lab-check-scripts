#!/bin/bash

# Author: Olari Pipenberg. 

# Example: bash check_higher_subnet_prefix.sh 30.0.127.2 eth5_ns eth5 30.0.127.14/28
# Best practice: use for HIGH_IP ip address from a same prefix as IP_ADR. HIGH_IP must be farthest ip from IP_ADR as possible.

IP_ADR=$1
NSPACE=$2
DEV=$3
HIGH_IP=$4



echo "Checking $IP_ADR" higher prefix:

# Saving current ip
CURRENT_IP=$(ip netns exec $NSPACE ip -o -4 addr list $DEV | awk '{print $4}')
# Check current ip, if address empty, then exit
if [ -z "$CURRENT_IP" ]; then
	exit 2
fi

# New ip
ip netns exec $NSPACE ip addr flush dev $DEV
ip netns exec $NSPACE ip addr add $HIGH_IP dev $DEV

ip netns exec $NSPACE fping -t 100 $IP_ADR > /dev/null

if [ $? -eq 0 ]; then
        echo "no higher prefix (ok)"
	# Restoring ip
	ip netns exec $NSPACE ip addr flush dev $DEV
	ip netns exec $NSPACE ip addr add $CURRENT_IP dev $DEV	
        exit 0
else
	echo "higher prefix (error)"
	# Restoring ip
	ip netns exec $NSPACE ip addr flush dev $DEV
        ip netns exec $NSPACE ip addr add $CURRENT_IP dev $DEV
	exit 1
fi
