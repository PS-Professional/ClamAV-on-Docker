#!/usr/bin/bash

#Functions
function wait(){
	echo "===========================" ; sleep 1
}

function status(){
	date ; uptime ; wait
	echo "ClamAV daemon status"
	/etc/init.d/clamav-daemon status ; wait
	echo "ClamAV virus database manager status"
	/etc/init.d/clamav-freshclam status ; wait
	echo "ClamAV recent logs"
	tail -15 /var/log/clamav/clamav.log ; wait
	echo "ClamAV virus database manager recent logs"
    tail -15 /var/log/clamav/freshclam.log ; wait
}

function fresh(){
	echo "Checking for database updates..."
	sleep 1
	freshclam
}

function os_update(){
	echo "Checking for packages' updates..."
	sleep 1
	apt update ; sleep 1
	apt upgrade -y ; sleep 1
}

function restart(){
	echo "Restarting ClamAV virus database manager..."
	sleep 1
	/etc/init.d/clamav-freshclam restart
	wait
	echo "Restarting ClamAV daemon..."
    sleep 1
    /etc/init.d/clamav-daemon restart
}

function help(){
	echo "Usege:"
    echo -e "status\t\t Show service status"
    echo -e "freshclam\t Update ClamAV virus databases"
    echo -e "update\t\t Check and update container packages"
    echo -e "restart\t\t Restart ClamAV services"
}
#Main function
sleep 1
case $1 in
	status )
		status;;
	freshclam )
		fresh;;
	update )
		os_update;;
	restart )
		restart;;
	* )
		help;;
esac
