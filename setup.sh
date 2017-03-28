#!/bin/bash
#########################################################################
# File Name: setup.sh
# Author: ##########
# ###############
# mail: #################
# Created Time: Tue 28 Mar 2017 06:13:29 PM CST
#########################################################################


source ./autobak.conf

mkdir -p ${BAK_PATH}

if [[ $AUTO_DRIVER == "cron" ]]
then
	echo "Using cron as auto driver"
	crontab -l > crontab.conf
	echo "$CRONTAB" >> crontab.conf
	crontab crontab.conf
	rm -f crontab.conf
fi

echo "We've done!"

echo "Note that you must config ssh public key before production!"
echo "You might want to trigger do.sh manually to ensure it works!"
echo "If you have never ssh the remote server, you have to add it to your trust list. This could be done by ssh it and type \"yes\"."
