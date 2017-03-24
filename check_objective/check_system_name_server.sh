#!/bin/bash

# Author: Olari Pipenberg
# Requirements: dnsmasq installed

# Following options must be set in dnsmasq.conf:
# 	log-queries
# 	log-facility=/var/log/dnsmasq.log

ROUTER_IP=$1

if [ $# -ne 1 ]; then
        echo "Usage: $(basename $0) <ipv4 address>"
        exit 1
fi

INPUT=$(grep -E -m 1 "query.*$ROUTER_IP" /var/log/dnsmasq.log | head -1)
if [[ $INPUT == *$ROUTER_IP* ]]; then
	echo "found"
	exit 0
else
	echo "not found"
	exit 2
fi
