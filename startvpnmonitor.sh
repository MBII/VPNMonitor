#!/bin/sh
cd ${0%/*}


# Name used to identify screen session
name=avpn_server1
# Path to server's log file
logpath=/home/mb2/.local/share/openjk/MBII/server1.log 
# Server's Port
rconport=29070
# Server's IP
rconip=127.0.0.1
# Whether to block uncertain VPN detections. See: https://iphub.info/api
uncertain=false
# Path to SQLite Database
databasepath=mb2db.sqlite
# Path to credentials file
credspath=credentials.txt


# Start function
startmonitor () {
	screen -SX $name quit > /dev/null
	screen -dmS $name ./vpnmonitor.sh $logpath $rconip $rconport $uncertain $databasepath $credspath
	if [ $? -eq 0 ]; then
		echo "started vpn monitoring, view using: screen -r $name"
	fi
}


# Start the VPN monitor
startmonitor

# To start multiple server monitors, modify the unique variables and run the function again
#name=avpn_server2
#logpath=/home/mb2/.local/share/openjk/MBII/server2.log 
#rconport=29071
#startmonitor
