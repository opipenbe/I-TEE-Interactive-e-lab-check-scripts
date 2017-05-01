#/bin/bash

# Author: Olari Pipenberg. 

ip netns exec eth2_ns ip route add default via 192.168.99.254
ip netns exec eth3_ns ip route add default via 192.168.88.254
ip netns exec eth4_ns ip route add default via 192.168.109.254

ip netns exec eth2_ns fping -t 100 30.0.127.1 > /dev/null &&
ip netns exec eth3_ns fping -t 100 30.0.127.1 > /dev/null &&
ip netns exec eth4_ns fping -t 100 30.0.127.1 > /dev/null &&
{
ip netns exec eth2_ns ip route del default via 192.168.99.254
ip netns exec eth3_ns ip route del default via 192.168.88.254
ip netns exec eth4_ns ip route del default via 192.168.109.254
echo "Private networks have internet access"
exit 0
}

ip netns exec eth2_ns ip route del default via 192.168.99.254
ip netns exec eth3_ns ip route del default via 192.168.88.254
ip netns exec eth4_ns ip route del default via 192.168.109.254
echo "Private networks do not have internet access"
exit 1
