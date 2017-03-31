#!/bin/bash

KEY_PATH="/root/e-lab-check-scripts/check_objective/ssh/id_rsa"
ssh -q -i $KEY_PATH vyos@30.0.127.2 exit
#echo $?
if [ $? -eq 0  ]; then
  echo "ssh-public-key-auth is configured"
  exit 0
else
  echo "ssh-public-key-auth is not configured"
  exit 1
fi



