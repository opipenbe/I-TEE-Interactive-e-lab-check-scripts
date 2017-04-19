#!/bin/bash
cd "$(dirname "$0")"
bash check_dns_forwarding.sh eth2_ns 192.168.99.254 gw.lab.zz
bash check_dns_forwarding.sh eth3_ns 192.168.88.254 gw.lab.zz 
