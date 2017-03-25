#!/bin/bash

# Author: Olari Pipenberg

IP_ADR=$1
NSPACE=$2
DEV=$3
LOW_IP=$4
HIGH_IP=$5

#bash check_subnet.sh 30.0.127.2 eth5_ns eth5
#Todo check if namespace is correct

# Check lower prefix
ip netns exec $NSPACE ping -w 2 -c 1 $IP_ADR > /dev/null ||
{
  echo "subnet ok!"
  exit 0
}
# Check higher prefix
#ip netns exec eth5_ns ip addr flush dev eth5

