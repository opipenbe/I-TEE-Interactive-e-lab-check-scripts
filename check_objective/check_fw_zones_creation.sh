#!/bin/bash

# This script must be after zones creation
# Do not run this script if firewall is not configured globally stateful
# This script checkfile must be saved persistently
PING_INTERVAL=1

ip netns exec eth2_ns ip route add default via 192.168.99.254
ip netns exec eth3_ns ip route add default via 192.168.88.254
ip netns exec eth4_ns ip route add default via 192.168.109.254

#Check from workstation subnet
ip netns exec eth2_ns ping 192.168.109.1 -c 1 -W $PING_INTERVAL > /dev/null ||
ip netns exec eth2_ns ping 192.168.88.1 -c 1 -W $PING_INTERVAL > /dev/null ||
ip netns exec eth2_ns ping 30.0.127.1 -c 1 -W $PING_INTERVAL > /dev/null || 

#Check from server subnet
ip netns exec eth3_ns ping 192.168.109.1 -c 1 -W $PING_INTERVAL > /dev/null  ||
ip netns exec eth3_ns ping 192.168.99.1 -c 1 -W $PING_INTERVAL > /dev/null ||
ip netns exec eth3_ns ping 30.0.127.1 -c 1 -W $PING_INTERVAL > /dev/null ||

#Check from guest subnet
ip netns exec eth4_ns ping 192.168.99.1 -c 1 -W $PING_INTERVAL > /dev/null  ||
ip netns exec eth4_ns ping 192.168.88.1 -c 1 -W $PING_INTERVAL > /dev/null ||
ip netns exec eth4_ns ping 30.0.127.1 -c 1 -W $PING_INTERVAL > /dev/null ||
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
