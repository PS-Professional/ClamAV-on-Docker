#!/usr/bin/env bash
set -o xtrace
set -o nounset
set -o pipefail

{
      echo 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*'
} | tee /test-clam/eicar.com

PROBLEM=0
for i in /test-clam/*
do 
	VIRUS_TEST=$(clamdscan --stream ${i} | grep -o FOUND)

	if [ $VIRUS_TEST == "FOUND" ]
	then
		echo "SUCCESS: Clamd working and detecting our test file (${i})"
	else
		echo "FAILED: Clamd is not detecting our test virus file (${i})"
		PROBLEM=1
	fi

done

if [ $PROBLEM = '1' ]
then
	/etc/init.d/clamav-freshclam restart
	/etc/init.d/clamav-daemon restart
	freshclam
fi
