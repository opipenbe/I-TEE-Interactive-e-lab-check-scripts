ping -W 2 -c 1 30.0.127.2 > /dev/null &&
echo "WAN interface is configured" || { echo "WAN interface is not configured"
                                      exit 1
                                    }
exit 0
