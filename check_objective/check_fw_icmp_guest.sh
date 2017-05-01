#/bin/bash

# Author: Olari Pipenberg. 

cd "$(dirname "$0")"
ip netns exec eth4_ns ip route add default via 192.168.109.254

! ip netns exec eth4_ns ./check_ssh.sh nopw > /dev/null &&
ip netns exec eth4_ns fping -t 100 192.168.109.254 > /dev/null &&
! ip netns exec eth4_ns ./check_ssh.sh nopw > /dev/null &&
ip netns exec eth4_ns ip route del default via 192.168.109.254 &&
echo "ICMP is configured for GUEST" &&
exit 0

ip netns exec eth4_ns ip route del default via 192.168.109.254
echo "ICMP is not configured for GUEST!"
exit 1
