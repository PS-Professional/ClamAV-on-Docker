#!/usr/bin/bash
/etc/init.d/clamav-freshclam start
/etc/init.d/clamav-daemon start
freshclam
echo "Everything ready to go!"
sleep 2
STATE=0
while [[ $STATE -eq 0 ]]
do
	CLAMD_STATE=`/etc/init.d/clamav-daemon status | grep 'Active' | sed  's/     //' | cut -f 2 -d ' '`
	if [[ $CLAMD_STATE -eq active ]]
	then
		echo 1 > /dev/null
	else
		/etc/init.d/clamav-daemon restart
	fi
done
