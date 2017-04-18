#!/bin/bash

# Do not run this script if firewall is not configured globally stateful
# This script checkfile must be saved persistently

#in ms
PING_TIMEOUT=100

#Check from workstation subnet
ip netns exec eth2_ns fping -t $PING_TIMEOUT 192.168.99.254 > /dev/null ||

#Check from server subnet
ip netns exec eth3_ns fping -t $PING_TIMEOUT 192.168.88.254 > /dev/null  ||

#Check from guest subnet
ip netns exec eth4_ns fping -t $PING_TIMEOUT 192.168.109.254 > /dev/null  ||

# Check from ISP network
fping -t $PING_TIMEOUT 30.0.127.2 > /dev/null ||
false 

if [ $? -eq 0  ]; then
  echo "Local zone is not configured"
  exit 1
fi

echo "Local zone is configured"
exit 0
