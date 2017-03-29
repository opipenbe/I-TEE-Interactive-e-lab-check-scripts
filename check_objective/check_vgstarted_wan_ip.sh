cd "$(dirname "$0")"
ping -W 1 -c 1 30.0.127.2 > /dev/null &&
bash check_lower_subnet_prefix.sh 30.0.127.2 eth5_ns eth5 30.0.127.30/27 &&
bash check_higher_subnet_prefix.sh 30.0.127.2 eth5_ns eth5 30.0.127.14/28 &&
echo "WAN interface is configured" || { echo "WAN interface is not configured"
                                      	exit 1
                                    }
exit 0
