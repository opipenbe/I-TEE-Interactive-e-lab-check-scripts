#!/bin/bash

# Requirements: dhcpcd5
# Error codes:
#   exit 0 - ok
#   exit 1 - wrong network
#   exit 2 - wrong subnet mask
#   exit 3 - wrong default gateway
#   exit 4 - wrong dns server
#   exit 5 - wrong lease

DEV=eth2

NETWORK="192.168.99.0"
SUBNET_MASK="255.255.255.0"
GW="192.168.99.254"
DNS_SERVER="192.168.99.254"
LEASE="86400"

INPUT=$(ip netns exec eth2_ns dhcpcd -T $DEV 2> /dev/null)

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

echo "dhcp attributes ok"
exit 0
