#!/bin/bash
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/bin/core_perl
time="$(date +%H:%M)"
microserver_mac='HIDDEN'
logfile="/var/log/serverPowerManage.log"

fping -c 1 microserver &> /dev/null

if [ $? -eq 0 ]; then
  microserver_up=0
else
  microserver_up=1
fi

if [[ $1 == "-wake" ]]; then
  if [ $microserver_up -eq 1 ]; then
    echo "MSG: Waking up microserver"
    wol $microserver_mac &> /dev/null
    exit 0
  else
    echo "MSG: Not waking up microserver as requested by user. It is already up"
  fi
fi

if [[ $microserver_up -eq 1 && "$time" = "12:40" ]]; then
	echo "$time MSG: It is now time to backup clients, and the microserver" \
		"isn't up"
	echo "$time ACTION: Waking up microserver"
	wol $microserver_mac
	exit 0
fi

if [ $microserver_up -eq 0 ]; then
	pcIps=(3 4 5 6 9 10 11 16 17 25 26 37 38)
	upCount=0

	echo "$time MSG: Microserver is up, checking whether any important hosts" \
		"are up"

	for i in "${pcIps[@]}"
	do
        	fping -c 1 -q 192.168.0.$i &> /dev/null

	        if [ $? -eq 0 ]; then
        	        upCount=$(expr $upCount + 1)
	        fi
	done

	echo "$time MSG: $upCount important host(s) up"

	if [ $upCount -eq 0 ]; then
		echo "$time ALERT: No important hosts are up. Shutting down microserver"
		ssh powerman@microserver sudo shutdown -h now
		exit 0
	else
    echo "$time MSG: Not shutting down microserver"
  fi
else
  echo "$time MSG: Microserver is down, not running network usage check"
  exit 0
fi

