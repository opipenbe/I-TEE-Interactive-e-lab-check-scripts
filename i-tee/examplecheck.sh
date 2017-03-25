#!/bin/bash
# Script for checking  HTTPS Security lab objectives
# Objective name - Installing Apache and Nginx

# Author - Katrin Loodus
# Modified by  Roland Kaur
#
# Date - 27.04.2016
# Version - 0.0.1

LC_ALL=C

# START
# HTTPSSECINST

# Set variables

START () {

	# Enable logging
	echo -e "\n$0 started on: $(date):" >> /var/log/labcheckslog.log
	exec &> >(tee -a /var/log/labcheckslog.log)

	# If $CheckFile exists, then exit the script
	CheckFile="/tmp/installer"

	if [ -f $CheckFile ]; then echo "$0 has already ran successfully" && exit 0; fi

    # Exit if there are undeclared variables
    set -o nounset     

	# Get working directory
	DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

	# IP to SSH to - devops server
	IP_to_SSH=192.168.6.2

	# Time to sleep between running the check again
	Sleep=5

	# Objective uname in VirtualTA
	Uname=httpsinstall


}

# User interaction: Install apache and nginx

HTTPSSECINST () {

	while true
	do

   	# Check if user has installed apache and nginx 
    	ssh root@$IP_to_SSH 'dpkg-query -l apache2 nginx'  

   	# Run objectiveschecks.py and update VirtualTa with correct value
    	if [ $? -eq 0 ]; then

        	echo -e "\nApache and nginx have been installed!! Date: `date`\n" && touch $CheckFile
        	$DIR/objectivechecks.py $Uname True || echo -e "\nFailed to run $DIR/objectiveschecks.py! Date: `date`" >&2 && exit 1
        	exit 0

    	else

        	echo -e "Apache and nginx have not been installed! Date: `date`\n" >&2
        	sleep $Sleep

    	fi
	done

}

START

HTTPSSECINST

exit 0

