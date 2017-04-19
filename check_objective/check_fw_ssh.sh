#/bin/bash
cd "$(dirname "$0")"
# adding default gw
ip netns exec eth2_ns ip route add default via 192.168.99.254
ip netns exec eth3_ns ip route add default via 192.168.88.254
ip netns exec eth4_ns ip route add default via 192.168.109.254


bash ./check_ssh.sh nopw > /dev/null &&
# Check Workstation subnet
! ip netns exec eth2_ns bash ./check_ssh.sh nopw > /dev/null &&
# Check Server subnet
! ip netns exec eth3_ns bash ./check_ssh.sh nopw > /dev/null &&
# Check Guest subnet
! ip netns exec eth4_ns bash ./check_ssh.sh nopw > /dev/null && 
true

if [ $? -eq 0  ]; then
  ip netns exec eth2_ns ip route del default via 192.168.99.254
  ip netns exec eth3_ns ip route del default via 192.168.88.254
  ip netns exec eth4_ns ip route del default via 192.168.109.254
  echo "Firewall for SSH is configured"
  exit 0
fi

ip netns exec eth2_ns ip route del default via 192.168.99.254
ip netns exec eth3_ns ip route del default via 192.168.88.254
ip netns exec eth4_ns ip route del default via 192.168.109.254
echo "Firewall for SSH is not configured"
exit 1
