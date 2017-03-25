#!/usr/bin/env python3

__author__ = 'margus'


import configparser
import requests
import os
import sys

if len(sys.argv) != 3:
    print("Wrong number of command line arguments!")
    print("Use it as ", sys.argv[0], "uname True|False")
    sys.exit(1)

config_filename = '/root/e-lab-check-scripts/i-tee/lab.ini'
config = configparser.ConfigParser()

print('Reading configuration from:', config_filename)
config = configparser.ConfigParser()
config.read(config_filename)
username = os.getenv('LAB_USERNAME')
try:

    if not username:
        raise NameError

    ta_key = config.get('LAB', 'ta_key')
    virtualta_hostname = config.get('LAB', 'virtualta_hostname')
    lab_id = config.get('LAB', 'lab_id')
except NameError:
    print("No LAB_USERNAME!", file=sys.stderr)
    sys.exit(1)

except Exception:
    print(" Exception no Ini file or LAB section inside ini file or wrong key values", file=sys.stderr)
    print("cat >> ../lab.ini<<END", file=sys.stderr)
    print("[LAB]", file=sys.stderr)
    print("ta_key = 'Your TA key here'", file=sys.stderr)
    print("virtualta_hostname ='Your virtualTA URL (http(s)://hostname:portname here'", file=sys.stderr)
    print("lab_id ='LAB ID'", file=sys.stderr)
    print("END", file=sys.stderr)

    sys.exit(1)

payload = {"api_key": ta_key,  "username":  username}


user_key = requests.get(virtualta_hostname + '/api/v1/userkey', data=payload, verify=False).text


payload = {"api_key": ta_key, "lab": lab_id, "user": user_key[1:-1], "uname": sys.argv[1], "done": sys.argv[2]}

print("SSH_TEST", requests.put(virtualta_hostname + '/api/v1/labuser', data=payload, verify=False).text)

