#!/bin/bash
cd "$(dirname "$0")"

ping -W 1 -c 1 30.0.127.2 > /dev/null &&
bash check_lower_subnet_prefix.sh 30.0.127.2 eth5_ns eth5 30.0.127.30/27 &&
bash check_higher_subnet_prefix.sh 30.0.127.2 eth5_ns eth5 30.0.127.14/28 &&

ping -W 1 -c 1 30.0.127.3 > /dev/null &&
bash check_lower_subnet_prefix.sh 30.0.127.3 eth5_ns eth5 30.0.127.30/27 &&
bash check_higher_subnet_prefix.sh 30.0.127.3 eth5_ns eth5 30.0.127.14/28 &&

ping -W 1 -c 1 30.0.127.4 > /dev/null &&
bash check_lower_subnet_prefix.sh 30.0.127.4 eth5_ns eth5 30.0.127.30/27 &&
bash check_higher_subnet_prefix.sh 30.0.127.4 eth5_ns eth5 30.0.127.14/28 &&

ping -W 1 -c 1 30.0.127.5 > /dev/null &&
bash check_lower_subnet_prefix.sh 30.0.127.5 eth5_ns eth5 30.0.127.30/27 &&
bash check_higher_subnet_prefix.sh 30.0.127.5 eth5_ns eth5 30.0.127.14/28 &&

ping -W 1 -c 1 30.0.127.6 > /dev/null &&
bash check_lower_subnet_prefix.sh 30.0.127.6 eth5_ns eth5 30.0.127.30/27 &&
bash check_higher_subnet_prefix.sh 30.0.127.6 eth5_ns eth5 30.0.127.14/28 &&

ping -W 1 -c 1 30.0.127.7 > /dev/null &&
bash check_lower_subnet_prefix.sh 30.0.127.7 eth5_ns eth5 30.0.127.30/27 &&
bash check_higher_subnet_prefix.sh 30.0.127.7 eth5_ns eth5 30.0.127.14/28 &&

# There is no need to check higher prefix in internal networks, becouse this machine internal network addresses end with  x.x.x.1,
# addresses to be checked are end with x.x.x.254 and we are dealing with /24 prefix.
./check_ip.sh eth2_ns 192.168.99.254 &&
bash check_lower_subnet_prefix.sh 192.168.99.254 eth2_ns eth2 192.168.98.1/23 &&

./check_ip.sh eth3_ns 192.168.88.254 &&
bash check_lower_subnet_prefix.sh 192.168.88.254 eth3_ns eth3 192.168.89.1/23 &&

./check_ip.sh eth4_ns 192.168.109.254 &&
bash check_lower_subnet_prefix.sh 192.168.109.254 eth4_ns eth4 192.168.108.1/23 &&

echo "Interfaces are configured" || { echo "Interfaces are not configured"
				      exit 1
			            }
exit 0

