#!/bin/bash

# Requirements: dhcpcd5
DEV=eth2

INPUT=$(ip netns exec eth2_ns dhcpcd -T $DEV 2> /dev/null)

# Check network
echo $INPUT | grep "new_network_number='192.168.99.0'" > /dev/null
if [ $? -ne 0  ]; then
	echo "wrong network (error)"
fi

# Check subnet mask
echo $INPUT | grep "new_subnet_mask='255.255.255.0'" > /dev/null
if [ $? -ne 0  ]; then
	echo "wrong subnet mask (error)"
fi

# Check default gateway
echo $INPUT | grep "new_routers='192.168.99.254'" > /dev/null
if [ $? -ne 0  ]; then
	echo "wrong default gateway (error)"
fi

# Check DNS server, TODO only one dns server
echo $INPUT | grep "new_domain_name_servers='192.168.99.254'" > /dev/null
if [ $? -ne 0  ]; then
	echo "wrong dns server (error)"
fi

# Check lease
echo $INPUT | grep "new_dhcp_lease_time='86400'" > /dev/null
if [ $? -ne 0  ]; then
	echo "wrong lease (error)"
fi

echo "dhcp attributes ok"
exit 0
