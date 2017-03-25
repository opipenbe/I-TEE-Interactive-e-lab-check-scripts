#!/bin/bash

export LAB_USERNAME=$(dmidecode -s bios-release-date)

dmidecode -s bios-version |grep 'vyos' >/dev/null 2>&1
if [ $? -eq 0 ]
then
    LAB_ID=P4ojLSRryaRReCYdM
else
    LAB_ID=P4ojLSRryaRReCYdM
fi

cat > lab.ini <<EOC
[LAB]
ta_key = 06473dab8ae4c8486b70fe59782d54e2
virtualta_hostname = https://i-tee.itcollege.ee:8433
lab_id = $LAB_ID
EOC

