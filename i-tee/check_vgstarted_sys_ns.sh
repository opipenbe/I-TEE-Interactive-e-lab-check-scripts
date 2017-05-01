#!/bin/bash


# Author - Katrin Loodus
# Modified by Olari Pipenberg

LC_ALL=C

# START
# HTTPSSECINST

# Set variables

START () {

	# Enable logging
	echo -e "\n$0 started on: $(date):" >> /var/log/labcheckslog.log
	exec &> >(tee -a /var/log/labcheckslog.log)

	# If $CheckFile exists, then exit the script
	CheckFile="/tmp/vgstarted_sys_ns"

	if [ -f $CheckFile ]; then echo "$0 has already ran successfully" && exit 0; fi

    	# Exit if there are undeclared variables
    	set -o nounset     

	# Get working directory
	DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

	# Time to sleep between running the check again
	Sleep=1

	# Objective uname in VirtualTA
	Uname=vgstartednameserver


}

VYOSGSTARTED () {
	while true
	do
	# Check nameserver configuration
	bash /root/e-lab-check-scripts/check_objective/check_system_name_server.sh 30.0.127.2
	if [ $? -eq 0 ]; then
		# Run objectiveschecks.py and update VirtualTa with correct value
		echo -e "\nWan interface configured! Date: `date`\n" && touch $CheckFile
        	$DIR/objectivechecks.py $Uname True || echo -e "\nFailed to run $DIR/objectiveschecks.py! Date: `date`" >&2 && exit 1
        	exit 0			
	fi
	sleep $Sleep
	done
}

START
VYOSGSTARTED

exit 0

