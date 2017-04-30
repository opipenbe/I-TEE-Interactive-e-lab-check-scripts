#!/bin/bash

# Error codes:
# 	1 - Wrong argument number
#	2 - Insufficient privileges
#	3 - Interface not found or namespace already exists
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
if [ ! -d /sys/class/net/$INTERFACE ]; then
	if [ -f /var/run/netns/$NAMESPACE ]; then
		echo "Network namespace $NAMESPACE already exists."	
	else
		echo "Interface $INTERFACE not found."
	fi
	exit 3
fi

/sbin/ip netns add $NAMESPACE &&
/sbin/ip link set $INTERFACE netns $NAMESPACE &&
/sbin/ip netns exec $NAMESPACE ip link set $INTERFACE up &&
/sbin/ip netns exec $NAMESPACE ip addr add $ADDRESS dev $INTERFACE &&

if [ $# -eq 4 ]; then
	/sbin/ip netns exec $NAMESPACE ip route add default via $GATEWAY dev $INTERFACE
fi

if [ $? -ne 0 ]; then
    /sbin/ip netns delete $NAMESPACE
    echo "Unknown error"
    exit 4
fi

echo "$NAMESPACE named network namespace successfully created."
echo "Use 'ip netns show' command to view your new network namespace."
