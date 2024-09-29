#!/bin/bash

logpath=$1
rconip=$2
rconport=$3
uncertain=$4
databasepath=$5
credspath=$6
if [ -f $credspath ]; then
    source $credspath
else
	echo "could not open credentials file"
	exit 1
fi

currentTime="date +%T"
connectFormat="^(\s|[0-9])+[0-9]+:[0-9]+\sClientConnect:.*IP:\s[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+"
echo "VPN monitor - original version by devon, modified by Spaghetti, further modified by 2cwldys"
echo "version 1.1 - 2021/9/12"
echo "`$currentTime` Monitoring `echo $logpath | awk -F '/' '{print $NF}'` for server at $rconip:$rconport"

#printf '\xFF\xFF\xFF\xFFrcon '"$rconpass"' status\n' | nc -u -n -w 1 $rconip $rconport | sed -ne ':x;/\xFF/{N;s/\xFF\xFF\xFF\xFFprint\n//;tx};/^$/d;p'
#allows you to send rcon commands to server, set password and address variables above and replace status with the rcon command

tail -n 0 -F "$logpath" | grep -E "$connectFormat" --line-buffered | while read line;
do
	IFS=': '
	read -a strarr <<< "$line"
	connectLine="${strarr[0]}:${strarr[1]}"
	connectName=${strarr[3]}
	connectID=${strarr[5]}
	connectIP=${strarr[7]}
	echo "`$currentTime` NEW CONNECTION : $connectLine $connectName $connectIP"
	
	result=$(sqlite3 "$databasepath" "SELECT vpn from iplist where ip='$connectIP'")
	if [ -z "$result" ]; then
		echo "`$currentTime` $connectIP : was not found in database"
		echo "`$currentTime` $connectIP : checking for VPN"
		response=$(curl -s http://v2.api.iphub.info/ip/"$connectIP" -H "X-Key: $apikey")
		echo "`$currentTime` $connectIP : $response" # uncomment if you need to debug the API response
		if [[ "$response" =~ '"block":0' ]]; then
			vpn=0
		elif [[ "$response" =~ '"block":1' ]]; then
			vpn=1
		elif [[ "$response" =~ '"block":2' ]]; then
			vpn=2
		else
			vpn=-1
		fi
			
		if [[ $vpn == 0 ]]; then
			echo "`$currentTime` $connectIP : no VPN detected"
			sqlite3 "$databasepath" "INSERT INTO iplist(ip, vpn) VALUES ('$connectIP', $vpn)"
			echo "`$currentTime` $connectIP : allowed"
		elif [[ $vpn == 2 && $uncertain == false ]]; then
			echo "`$currentTime` $connectIP : potential VPN detected"
			sqlite3 "$databasepath" "INSERT INTO iplist(ip, vpn) VALUES ('$connectIP', $vpn)"
			printf '\xFF\xFF\xFF\xFFrcon '"$rconpass"' svsay ^3Potential VPN detection for client '"$connectID"'\n' | nc -u -n -w 1 $rconip $rconport > /dev/null
			echo "`$currentTime` $connectIP : allowed & warned"
		elif [[ $vpn == 1 || $vpn == 2 ]]; then
			echo "`$currentTime` $connectIP : VPN detected, kicked in 15 seconds!"
			printf '\xFF\xFF\xFF\xFFrcon '"$rconpass"' svsay ^5[Bot] ^1VPN ^7use detected! ^3'"$connectID"' ^7kicked in 15 seconds!\n' | nc -u -n -w 1 $rconip $rconport > /dev/null
			sqlite3 "$databasepath" "INSERT INTO iplist(ip, vpn) VALUES ('$connectIP', $vpn)"
			printf '\xFF\xFF\xFF\xFFrcon '"$rconpass"' addip '"$connectIP"'\n' | nc -u -n -w 1 $rconip $rconport > /dev/null
			printf '\xFF\xFF\xFF\xFFrcon '"$rconpass"' marktk '"$connectID"'\n' | nc -u -n -w 1 $rconip $rconport > /dev/null
			printf '\xFF\xFF\xFF\xFFrcon '"$rconpass"' mute '"$connectID"'\n' | nc -u -n -w 1 $rconip $rconport > /dev/null
			sleep 5s
			echo "`$currentTime` $connectIP : VPN detected, kicked in 10 seconds!"
			printf '\xFF\xFF\xFF\xFFrcon '"$rconpass"' svsay ^5[Bot] ^1VPN ^7use detected! ^3'"$connectID"' ^7kicked in 10 seconds!\n' | nc -u -n -w 1 $rconip $rconport > /dev/null
			printf '\xFF\xFF\xFF\xFFrcon '"$rconpass"' marktk '"$connectID"'\n' | nc -u -n -w 1 $rconip $rconport > /dev/null
			sleep 5s
			echo "`$currentTime` $connectIP : VPN detected, kicked in 5 seconds!"
			printf '\xFF\xFF\xFF\xFFrcon '"$rconpass"' svsay ^5[Bot] ^1VPN ^7use detected! ^3'"$connectID"' ^7kicked in 5 seconds!\n' | nc -u -n -w 1 $rconip $rconport > /dev/null
			printf '\xFF\xFF\xFF\xFFrcon '"$rconpass"' marktk '"$connectID"'\n' | nc -u -n -w 1 $rconip $rconport > /dev/null
			sleep 5s
			printf '\xFF\xFF\xFF\xFFrcon '"$rconpass"' kick '"$connectID"'\n' | nc -u -n -w 1 $rconip $rconport > /dev/null
			printf '\xFF\xFF\xFF\xFFrcon '"$rconpass"' svsay ^5[Bot] ^1Banned client ^3'"$connectID"' ^1for VPN use!\n' | nc -u -n -w 1 $rconip $rconport > /dev/null
			echo "`$currentTime` $connectIP : banned & kicked."
		else	
			echo "invalid response, doing nothing"
		fi
	else
		echo "`$currentTime` $connectIP : already in DB, skipping checks"
	fi
done
