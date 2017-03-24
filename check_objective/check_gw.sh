#/bin/bash
# Author: Olari Pipenberg
# NOTE that gw and interfaces check script cant be run same time

GW_ADDR="192.168.99.254"
NSPACE="eth2_ns"
NSPACE_DEV="eth2"
CAP_DEV="eth1"
SRC_IP="192.168.99.1"
DST_IP="30.0.127.1"

# Set gateway
/sbin/ip netns exec $NSPACE ip route add default via $GW_ADDR dev $NSPACE_DEV

# Start capturing icmp traffic
tshark -i $CAP_DEV -f "icmp" > /tmp/traffic < /dev/null 2>&1 &

# Send icmp traffic
ip netns exec $NSPACE ping -c 1 -w 4 $DST_IP > /dev/null

# Stop tshark
pkill tshark

# Wait for tshark buffer
sleep 1

cat /tmp/traffic
#rm /tmp/traffic

# Delete gateway
/sbin/ip netns exec $NSPACE ip route del default via $GW_ADDR dev eth2
