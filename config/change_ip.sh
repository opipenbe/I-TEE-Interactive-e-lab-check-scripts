#!/bin/bash
MACHINE="vyos-fw"
DMIDECODEVERSION="$(dmidecode -s bios-version | cut -d'-' -f1,2)"

if [ "$DMIDECODEVERSION" == "$MACHINE" ]; then
  ip addr flush dev eth0
  ip addr add 192.168.88.200/24 dev eth0
  ip route add default via 192.168.88.254
cat > /etc/resolv.conf <<EOC
domain lab.zz
search lab.zz.
nameserver 192.168.88.254
EOC
fi


