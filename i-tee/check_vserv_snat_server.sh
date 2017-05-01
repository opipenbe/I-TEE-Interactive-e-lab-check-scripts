#!/bin/bash

# Author - Katrin Loodus
# Modified by Olari Pipenberg


LC_ALL=C

# START

# Set variables

START () {

	# Enable logging
	echo -e "\n$0 started on: $(date):" >> /var/log/labcheckslog.log
	exec &> >(tee -a /var/log/labcheckslog.log)

	# Objective uname in VirtualTA
        Uname="vservsnatserver"

	# If $CheckFile exists, then exit the script
	CheckFile="/tmp/$Uname"

	if [ -f $CheckFile ]; then echo "$0 has already ran successfully" && exit 0; fi

    	# Exit if there are undeclared variables
    	set -o nounset     

	# Get working directory
	DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

	# Time to sleep between running the check again
	Sleep=1
}

VSERV () {
	while true
	do
	bash /root/e-lab-check-scripts/check_objective/check_snat_server.sh
	if [ $? -eq 0 ]; then
		# Run objectiveschecks.py and update VirtualTa with correct value
		echo -e "\nStep Complete! Date: `date`\n" && touch $CheckFile
        	$DIR/objectivechecks.py $Uname True || echo -e "\nFailed to run $DIR/objectiveschecks.py! Date: `date`" >&2 && exit 1
        	exit 0			
	fi
	sleep $Sleep
	done
}

START
VSERV

exit 0

