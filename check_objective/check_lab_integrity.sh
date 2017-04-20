#!/bin/bash


fping -t 100 30.0.127.2 &&
ip netns exec eth2_ns fping -t 100 192.168.99.254 &&
ip netns exec eth3_ns fping -t 100 192.168.88.254 &&
ip netns exec eth4_ns fping -t 100 192.168.109.254 &&
{
  echo "VyOS network interfaces are responding"
  exit 0
}
echo "VyOS network interfaces are not responding"
exit 1
