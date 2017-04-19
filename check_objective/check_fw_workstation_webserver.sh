#!/bin/bash
PORT="80"
ADDRESS="192.168.88.200"

ip netns exec eth2_ns ip route add default via 192.168.99.254

ip netns exec eth2_ns nc -z -w 1 $ADDRESS $PORT
if [ $? -ne 0  ]; then
  ip netns exec eth2_ns ip route del default via 192.168.99.254
  echo "Firewall: port: $PORT is not configured for $ADDRESS"
  exit 1
fi

# Check rule-set destination address
SRC_IP="192.168.99.1"
DST_IP="192.168.88.1"
# Start capturing HTTP traffic
ip netns exec eth3_ns tshark -i eth3 > /tmp/traffic &

# Send HTTP traffic
ip netns exec eth2_ns nc -z -w 4 $DST_IP $PORT > /dev/null

# Stop tshark
pkill tshark
wait $(jobs -rp) 2>/dev/null

grep "$SRC_IP -> $DST_IP" /tmp/traffic > /dev/null
if [ $? -eq 0  ]; then
  ip netns exec eth4_ns ip route del default via 192.168.99.254
  echo "Destination address is too wide"
  exit 2
fi


# Check if firewall rule isnt too wide (ssh should not be open)
ip netns exec eth2_ns nc -z -w 1 $ADDRESS 22
if [ $? -ne 0  ]; then
  ip netns exec eth2_ns ip route del default via 192.168.99.254
  echo "Firewall: port: $PORT is configured for $ADDRESS"
  exit 0
fi

ip netns exec eth2_ns ip route del default via 192.168.99.254
echo "Firewall rule is too wide"
exit 1

