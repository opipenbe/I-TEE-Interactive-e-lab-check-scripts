#!/bin/bash

DHCP_SERVER="192.168.88.254"
CHECK_IP="192.168.88.200/24"
NSPACE="eth3_ns"
DEV="eth3"

# Saving current ip
CURRENT_IP=$(ip netns exec $NSPACE ip -o -4 addr list $DEV | awk '{print $4}')
# Check current ip, if address empty then exit
if [ -z "$CURRENT_IP" ]; then
        exit 2
fi

# New ip
ip netns exec $NSPACE ip addr flush dev $DEV
ip netns exec $NSPACE ip addr add $CHECK_IP dev $DEV


# Find mac address


ip netns exec $NSPACE dhcping -h 08:00:27:61:fc:be -c 192.168.88.200 -s $DHCP_SERVER || {
                                                                echo "not set"
                                                                ip netns exec $NSPACE ip addr flush dev $DEV
                                                                ip netns exec $NSPACE ip addr add $CURRENT_IP dev $DEV
                                                                exit 1
                                                                }
# Restore old ip
ip netns exec $NSPACE ip addr flush dev $DEV
ip netns exec $NSPACE ip addr add $CURRENT_IP dev $DEV
