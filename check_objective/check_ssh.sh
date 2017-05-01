#!/bin/bash

# Author: Olari Pipenberg. 

KEY_PATH="/root/e-lab-check-scripts/check_objective/ssh/id_rsa"
USERNAME="zeus"
IP="30.0.127.2"
PORT="28960"

# If argument is set then we skip ssh password auth check
if [ -z "$1"  ]; then
  # Checks password auth
  ssh -o ConnectTimeout=1 -o StrictHostKeyChecking=no -o PreferredAuthentications=none -p $PORT $USERNAME@$IP 2>&1 >/dev/null | grep password > /dev/null
  if [ $? -eq 0  ]; then
    echo "ssh password-auth is enabled (error)"
    exit 1
  fi
fi
# Checks public-key auth
ssh -o ConnectTimeout=1 -o StrictHostKeyChecking=no -q -i $KEY_PATH -p $PORT $USERNAME@$IP 'exit'
if [ $? -eq 0  ]; then
  echo "ssh-public-key-auth is configured"
  exit 0
else
  echo "ssh-public-key-auth is not configured"
  exit 2
fi



