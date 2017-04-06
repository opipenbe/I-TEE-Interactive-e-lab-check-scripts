#!/bin/bash
PORT="80"
ADDRESS="30.0.127.3"
NSPACE="eth2_ns"
GW="192.168.99.254"

ip netns exec $NSPACE ip route add default via $GW

ip netns exec $NSPACE nc -z $ADDRESS $PORT
if [ $? -ne 0  ]; then
  ip netns exec $NSPACE ip route del default via $GW
  echo "PAT for address: $ADDRESS and port: $PORT is not configured"
  exit 1
fi

# Check if dnat rule is too wide (ssh should not be open)
ip netns exec $NSPACE nc -z $ADDRESS 22
if [ $? -ne 0  ]; then
  ip netns exec $NSPACE ip route del default via $GW
  echo "PAT for address: $ADDRESS and port: $PORT is configured"
  exit 0
fi

ip netns exec $NSPACE ip route add default via $GW
echo "DNAT rule is too wide"
exit 1

