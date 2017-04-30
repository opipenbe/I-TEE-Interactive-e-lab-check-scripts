#!/bin/bash
# go to working directory
cd "$(dirname "$0")"
# this namespace is for workstation subnet
./create_namespace.sh eth2 eth2_ns 192.168.99.1/24
# this namespace is for server subnet
./create_namespace.sh eth3 eth3_ns 192.168.88.1/24
# this namespace is for guest subnet
./create_namespace.sh eth4 eth4_ns 192.168.109.1/24
# this namespace is for ISP subnet
./create_namespace.sh eth5 eth5_ns 30.0.127.14/28

