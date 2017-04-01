#!/bin/bash

# Requirements: dhcpcd5, dhcping
# Error codes:
#   exit 0 - ok
#   exit 1 - wrong network
#   exit 2 - wrong subnet mask
#   exit 3 - wrong default gateway
#   exit 4 - wrong dns server
#   exit 5 - wrong lease

DHCP_SERVER="192.168.99.254"
START_IP="192.168.99.10/24"
END_IP="192.168.99.200/24"
NETWORK="192.168.99.0"
SUBNET_MASK="255.255.255.0"
GW="192.168.99.254"
DNS_SERVER="192.168.99.254"
LEASE="86400"
NSPACE="eth2_ns"
DEV="eth2"

# Saving current ip
CURRENT_IP=$(ip netns exec $NSPACE ip -o -4 addr list $DEV | awk '{print $4}')
# Check current ip, if address empty then exit
if [ -z "$CURRENT_IP" ]; then
        exit 2
fi

# New ip
ip netns exec $NSPACE ip addr flush dev $DEV
ip netns exec $NSPACE ip addr add $START_IP dev $DEV
ip netns exec $NSPACE dhcping -c $START_IP -s $DHCP_SERVER -h 08:00:27:50:27:22  > /dev/null || {
								  echo "wrong dhcp pool start address"
								  ip netns exec $NSPACE ip addr flush dev $DEV
								  ip netns exec $NSPACE ip addr add $CURRENT_IP dev $DEV
								  exit 1
								}
# New ip
ip netns exec $NSPACE ip addr flush dev $DEV
ip netns exec $NSPACE ip addr add $END_IP dev $DEV
ip netns exec $NSPACE dhcping -c $END_IP -s $DHCP_SERVER -h 08:00:27:50:27:22 > /dev/null || {
								echo "wrong dhcp pool end address"
								ip netns exec $NSPACE ip addr flush dev $DEV
								ip netns exec $NSPACE ip addr add $CURRENT_IP dev $DEV
								exit 1
							      }

# Restoring ip
ip netns exec $NSPACE ip addr flush dev $DEV
ip netns exec $NSPACE ip addr add $CURRENT_IP dev $DEV


# Check authoritative
ip netns exec $NSPACE dhcping -s $DHCP_SERVER > /dev/null
if [ $? -ne 0  ]; then
        echo "not authoritative (error)"
        exit 1
fi



INPUT=$(ip netns exec $NSPACE dhcpcd -T $DEV 2> /dev/null)

# Check network
echo $INPUT | grep "new_network_number='$NETWORK'" > /dev/null
if [ $? -ne 0  ]; then
	echo "wrong network (error)"
	exit 1
fi

# Check subnet mask
echo $INPUT | grep "new_subnet_mask='$SUBNET_MASK'" > /dev/null
if [ $? -ne 0  ]; then
	echo "wrong subnet mask (error)"
	exit 2
fi

# Check default gateway
echo $INPUT | grep "new_routers='$GW'" > /dev/null
if [ $? -ne 0  ]; then
	echo "wrong default gateway (error)"
	exit 3
fi

# Check DNS server, TODO only one dns server
echo $INPUT | grep "new_domain_name_servers='$DNS_SERVER'" > /dev/null
if [ $? -ne 0  ]; then
	echo "wrong dns server (error)"
	exit 4
fi

# Check lease
echo $INPUT | grep "new_dhcp_lease_time='$LEASE'" > /dev/null
if [ $? -ne 0  ]; then
	echo "wrong lease (error)"
	exit 5
fi

echo "dhcp pool + attributes ok"
exit 0
