#!/bin/bash
PORT="80"
ADDRESS="30.0.127.3"

nc -z -w 1 $ADDRESS $PORT
if [ $? -ne 0  ]; then
  echo "PAT for address: $ADDRESS and port: $PORT is not configured"
  exit 1
fi

# Check if dnat rule is too wide (ssh should not be open)
nc -z -w 1 $ADDRESS 22
if [ $? -ne 0  ]; then
  echo "PAT for address: $ADDRESS and port: $PORT is configured"
  exit 0
fi

echo "DNAT rule is too wide"
exit 1

