#!/bin/bash

export LAB_USERNAME=$(dmidecode -s bios-release-date)

LAB_MACHINE=$(dmidecode -s bios-version)
if [[ $LAB_MACHINE == "vyos-gst"* ]]; then 
   LAB_ID=P4ojLSRryaRReCYdM
elif [[ $LAB_MACHINE == "vyos-serv"* ]]; then
   LAB_ID=ayx9XjvvXoZg5j7dq
else
   LAB_ID=P4ojLSRryaRReCYdM
fi

cat > lab.ini <<EOC
[LAB]
ta_key = 06473dab8ae4c8486b70fe59782d54e2
virtualta_hostname = https://i-tee.itcollege.ee:8433
lab_id = $LAB_ID
EOC
