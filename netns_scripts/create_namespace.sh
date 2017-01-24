#!/bin/bash

# Created by Olari Pipenberg. 
# Feel free to change, add, and remove any part of this script.
# Error codes:
# 	1 - wrong argument number
#	2 - Insufficient privileges
#	3 - Interface not found
#	4 - Unknown error

# Check arguments
if [ $# -eq 4 ]; then
	INTERFACE=$1
	NAMESPACE=$2
	ADDRESS=$3
	GATEWAY=$4
else
        if [ $# -eq 3 ]; then
            INTERFACE=$1
            NAMESPACE=$2
            ADDRESS=$3
         else
            echo "Usage: $(basename $0) <interface> <namespace> <address> <gateway>"
	    echo "Example: $(basename $0) eth0 eth0_ns 192.168.1.0/24 192.168.1.254"
            exit 1
         fi
fi

# Check privileges
if [ $"$EUID" -ne 0 ]; then
	echo "Insufficient privileges"
	exit 2
fi

# Check interface
FILE="/sys/class/net/$INTERFACE"
if [ ! -d /sys/class/net/$INTERFACE ]; then
	echo "Interface $INTERFACE not found."
	exit 3
fi

/sbin/ip netns add $NAMESPACE &&
/sbin/ip link set $INTERFACE netns $NAMESPACE &&
/sbin/ip netns exec $NAMESPACE ip link set $INTERFACE up &&
/sbin/ip netns exec $NAMESPACE ip addr add $ADDRESS dev $INTERFACE &&
/sbin/ip netns exec $NAMESPACE ip route add default via $ADDRESS dev $INTERFACE

if [ $? -ne 0 ]; then
    echo "Unknown error"
    exit 4
fi

echo "$NAMESPACE named networks namespace successfully created."
echo "Use 'ip netns show' command to view your new network namespace."
