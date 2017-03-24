#!/bin/bash
ping -W 2 -c 1 30.0.127.2 > /dev/null &&
./check_ip.sh eth2_ns 192.168.99.254 &&
./check_ip.sh eth3_ns 192.168.88.254 &&
./check_ip.sh eth4_ns 192.168.109.254 &&
echo "works" &&
exit 0

