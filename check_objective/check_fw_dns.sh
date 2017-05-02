#!/bin/bash

# Author: Olari Pipenberg. 

cd "$(dirname "$0")"

ip netns exec eth2_ns ip route add default via 192.168.99.254
ip netns exec eth3_ns ip route add default via 192.168.88.254

bash check_dns_forwarding.sh eth2_ns 192.168.99.254 gw.lab.zz > /dev/null &&
bash check_dns_forwarding.sh eth3_ns 192.168.88.254 gw.lab.zz > /dev/null &&
! ip netns exec eth2_ns ./check_ssh.sh nopw > /dev/null &&
! ip netns exec eth3_ns ./check_ssh.sh nopw > /dev/null &&
ip netns exec eth2_ns ip route del default via 192.168.99.254 &&
ip netns exec eth3_ns ip route del default via 192.168.88.254 &&
echo "DNS allowed (ok)" &&
exit 0

ip netns exec eth2_ns ip route del default via 192.168.99.254
ip netns exec eth3_ns ip route del default via 192.168.88.254
echo "DNS is not allowed (error)"
exit 1
