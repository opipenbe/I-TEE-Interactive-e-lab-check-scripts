#!/bin/bash
# Author: Olari Pipenberg

# Check arguments
# Error codes 
# exit 0 - pinging
# exit 1 - wrong number of arguments
# exit 2 - namespace not found
# exit 3 - not pinging

NSPACE=$1
IP_ADR=$2

if [ $# -ne 2 ]; then
	echo "Usage: $(basename $0) <namespace> <ipv4 address>"
	exit 1
fi

ip netns | grep -w "$NSPACE" > /dev/null || exit 2

ip netns exec $NSPACE ping -W 2 -c 1 $IP_ADR > /dev/null || exit 3

exit 0 # pinging
