#!/bin/bash

# Author: Olari Pipenberg. 

DHCP_SERVER="192.168.88.254"
CHECK_IP="192.168.88.200/24"
NSPACE="eth3_ns"
DEV="eth3"


# Check if host is configured with correct ip address
ip netns exec $NSPACE ping ${CHECK_IP::-3} -c 1 -W 1 > /dev/null
if [ $? -ne 0 ]; then
	echo "Host is not configured"
        exit 1
fi

#Find host mac address
MAC=$(ip netns exec $NSPACE arp -a | grep ${CHECK_IP::-3} | awk '{print $4}')

# Saving current ip
CURRENT_IP=$(ip netns exec $NSPACE ip -o -4 addr list $DEV | awk '{print $4}')
# Check current ip, if address empty then exit
if [ -z "$CURRENT_IP" ]; then
        exit 2
fi

# New ip
ip netns exec $NSPACE ip addr flush dev $DEV
ip netns exec $NSPACE ip addr add $CHECK_IP dev $DEV


ip netns exec $NSPACE dhcping -h $MAC -c $CHECK_IP -s $DHCP_SERVER > /dev/null || {
                                                                echo "Static map is not set"
                                                                ip netns exec $NSPACE ip addr flush dev $DEV
                                                                ip netns exec $NSPACE ip addr add $CURRENT_IP dev $DEV
                                                                exit 1
                                                                }
# Restore old ip
ip netns exec $NSPACE ip addr flush dev $DEV
ip netns exec $NSPACE ip addr add $CURRENT_IP dev $DEV

echo "Static map is set"
exit 0
