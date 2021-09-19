#!/bin/sh

stopmonitor () {
	screen -SX $1 quit
	if [ $? -eq 0 ]; then
		echo "stopped vpn monitoring for $1"
	fi
}

stopmonitor avpn_server1

# To stop multiple server monitors, run the function again with the unique screen name
#stopmonitor avpn_server2
