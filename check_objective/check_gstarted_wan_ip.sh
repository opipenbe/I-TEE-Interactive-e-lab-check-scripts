ping -W 2 -c 1 30.0.127.2 > /dev/null &&
echo "Interfaces are configured" || { echo "Interfaces are not configured"
                                      exit 1
                                    }
exit 0
