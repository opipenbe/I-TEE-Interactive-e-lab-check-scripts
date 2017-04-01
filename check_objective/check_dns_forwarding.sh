#!/bin/bash

NSPACE=$1
HOSTNAME="vyos"
IP="$2"

if [ $# -ne 2 ]; then
        echo "Usage: $(basename $0) <namespace> <ipv4 address>"
        exit 1
fi

ip netns exec $NSPACE host -W 1 $HOSTNAME $IP > /dev/null || {
  							  echo "dns forwarding not configured"
  							  exit 1
							}
echo "dns forwarding is configured"
exit 0
