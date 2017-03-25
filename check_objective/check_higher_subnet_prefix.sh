#!/bin/bash

# Author: Olari Pipenberg

IP_ADR=$1
NSPACE=$2
DEV=$3
HIGH_IP=$4

# bash check_lower_subnet_prefix.sh 30.0.127.2 eth5_ns eth5 30.0.127.14/28
# TODO check if namespace is correct.


CURRENT_IP=$(ip netns exec $NSPACE ip -o -4 addr list $DEV | awk '{print $4}')
ip netns exec $NSPACE ip addr flush dev $DEV
ip netns exec $NSPACE ip addr add $HIGH_IP dev $DEV

ip netns exec $NSPACE ping -w 1 -c 1 $IP_ADR > /dev/null

if [ $? -eq 0 ]; then
        echo "subnet ok"
	ip netns exec $NSPACE ip addr flush dev $DEV
	ip netns exec $NSPACE ip addr add $CURRENT_IP dev $DEV	
        exit 0
else
	echo "wrong subnet"
	ip netns exec $NSPACE ip addr flush dev $DEV
        ip netns exec $NSPACE ip addr add $CURRENT_IP dev $DEV
	exit 1
fi
