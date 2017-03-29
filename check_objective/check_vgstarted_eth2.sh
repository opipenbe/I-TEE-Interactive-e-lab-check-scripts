#!/bin/bash
cd "$(dirname "$0")"

# There is no need to check higher prefix in internal networks, becouse checker machine (ISP) internal network addresses end with  x.x.x.1,
# addresses to be checked end with x.x.x.254 and we are dealing with /24 prefix.

./check_ip.sh eth3_ns 192.168.88.254 &&
bash check_lower_subnet_prefix.sh 192.168.88.254 eth3_ns eth3 192.168.89.1/23 &&

echo "Interface is configured" || { echo "Interface is not configured"
				      exit 1
			            }
exit 0

