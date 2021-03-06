#!/bin/bash

# Author: Olari Pipenberg. 

PORT="80"
ADDRESS="30.0.127.3"
NSPACE="eth4_ns"
GW="192.168.109.254"

ip netns exec $NSPACE ip route add default via $GW

ip netns exec $NSPACE nc -z -w 1 $ADDRESS $PORT
if [ $? -ne 0  ]; then
  ip netns exec $NSPACE ip route del default via $GW
  echo "PAT for address: $ADDRESS and port: $PORT is not configured"
  exit 1
fi

# Check if dnat rule is not too wide (ssh should not be open)
ip netns exec $NSPACE nc -z -w 1 $ADDRESS 22
if [ $? -ne 0  ]; then
  ip netns exec $NSPACE ip route del default via $GW
  echo "PAT for address: $ADDRESS and port: $PORT is configured"
  exit 0
fi

ip netns exec $NSPACE ip route add default via $GW
echo "DNAT rule is too wide"
exit 1

