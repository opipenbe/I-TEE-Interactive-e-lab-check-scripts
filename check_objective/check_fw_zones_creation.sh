#!/bin/bash

# This script must be after zones creation
# Do not run this script if firewall is not configured globally stateful
# This script checkfile must be saved persistently

#in ms
PING_TIMEOUT=150

ip netns exec eth2_ns ip route add default via 192.168.99.254
ip netns exec eth3_ns ip route add default via 192.168.88.254
ip netns exec eth4_ns ip route add default via 192.168.109.254

#Check from workstation subnet
ip netns exec eth2_ns fping 192.168.109.1 192.168.88.1 30.0.127.1 -t $PING_TIMEOUT > /dev/null ||

#Check from server subnet
ip netns exec eth3_ns fping 192.168.109.1 192.168.99.1 30.0.127.1 -t $PING_TIMEOUT > /dev/null  ||

#Check from guest subnet
ip netns exec eth4_ns fping 192.168.99.1 192.168.88.1 30.0.127.1 -t $PING_TIMEOUT > /dev/null  ||
false 

if [ $? -eq 0  ]; then
  ip netns exec eth2_ns ip route del default via 192.168.99.254
  ip netns exec eth3_ns ip route del default via 192.168.88.254
  ip netns exec eth4_ns ip route del default via 192.168.109.254
  echo "Zones are not configured"
  exit 1
fi

ip netns exec eth2_ns ip route del default via 192.168.99.254
ip netns exec eth3_ns ip route del default via 192.168.88.254
ip netns exec eth4_ns ip route del default via 192.168.109.254
echo "Zones are configured"
exit 0
