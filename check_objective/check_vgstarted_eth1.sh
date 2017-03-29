#!/bin/bash
cd "$(dirname "$0")"

# There is no need to check higher prefix in internal networks, becouse checker machine (ISP) internal network addresses end with  x.x.x.1,
# addresses to be checked end with x.x.x.254 and we are dealing with /24 prefix.
./check_ip.sh eth2_ns 192.168.99.254 &&
bash check_lower_subnet_prefix.sh 192.168.99.254 eth2_ns eth2 192.168.98.1/23 &&

echo "Interface is configured" || { echo "Interface is not configured"
				      exit 1
			            }
exit 0

