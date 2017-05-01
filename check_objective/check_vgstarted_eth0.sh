#!/bin/bash

# Author: Olari Pipenberg. 

cd "$(dirname "$0")"

fping -t 100 30.0.127.2 > /dev/null &&
bash check_lower_subnet_prefix.sh 30.0.127.2 eth5_ns eth5 30.0.127.30/27 &&
bash check_higher_subnet_prefix.sh 30.0.127.2 eth5_ns eth5 30.0.127.14/28 &&

fping -t 100 30.0.127.3 > /dev/null &&
bash check_lower_subnet_prefix.sh 30.0.127.3 eth5_ns eth5 30.0.127.30/27 &&
bash check_higher_subnet_prefix.sh 30.0.127.3 eth5_ns eth5 30.0.127.14/28 &&

fping -t 100 30.0.127.4 > /dev/null &&
bash check_lower_subnet_prefix.sh 30.0.127.4 eth5_ns eth5 30.0.127.30/27 &&
bash check_higher_subnet_prefix.sh 30.0.127.4 eth5_ns eth5 30.0.127.14/28 &&

fping -t 100 30.0.127.5 > /dev/null &&
bash check_lower_subnet_prefix.sh 30.0.127.5 eth5_ns eth5 30.0.127.30/27 &&
bash check_higher_subnet_prefix.sh 30.0.127.5 eth5_ns eth5 30.0.127.14/28 &&

echo "Interface is configured" || { echo "Interfaces is not configured"
				      exit 1
			            }
exit 0

