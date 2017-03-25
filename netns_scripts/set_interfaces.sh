#!/bin/bash
# Get working directory
cd "$(dirname "$0")"
./create_namespace.sh eth2 eth2_ns 192.168.99.1/24
./create_namespace.sh eth3 eth3_ns 192.168.88.1/24
./create_namespace.sh eth4 eth4_ns 192.168.109.1/24

# this interface is for subnet checking
./create_namespace.sh eth5 eth5_ns 30.0.127.30/27

