#!/bin/bash

# Author: Olari Pipenberg. 

cd "$(dirname "$0")"
bash check_dns_forwarding.sh eth2_ns 192.168.99.254 gw.lab.zz > /dev/null &&
bash check_dns_forwarding.sh eth3_ns 192.168.88.254 gw.lab.zz > /dev/null &&
echo "DNS allowed (ok)" &&
exit 0

echo "DNS is not allowed (error)"
exit 1
