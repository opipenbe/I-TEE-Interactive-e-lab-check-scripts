#!/bin/bash

# Author: Olari Pipenberg. 


NSPACE=$1
IP="$2"
HOSTNAME="$3"

if [ $# -ne 3 ]; then
        echo "Usage: $(basename $0) <namespace> <ipv4 address> <hostname>"
        exit 1
fi

ip netns exec $NSPACE host -W 1 $HOSTNAME $IP > /dev/null  || {
  							  echo "dns forwarding for $HOSTNAME  is not configured in $IP"
  							  exit 1
							}
echo "dns forwarding for $HOSTNAME is configured in $IP"
exit 0
