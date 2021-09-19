#!/bin/bash
echo "installing sqlite3 and screen"
sudo apt install sqlite3 screen
echo "creating database 'mb2db.sqlite'"
sqlite3 mb2db.sqlite "CREATE TABLE iplist (id INTEGER PRIMARY KEY AUTOINCREMENT, ip varchar(30), vpn int, date DATETIME DEFAULT CURRENT_TIMESTAMP);"
echo "finished creating database 'mb2db.sqlite'"
echo "before starting the monitor please make sure you have already edited 'startvpnmonitor.sh', 'stopvpnmonitor.sh', and 'credentials.txt' with required variables -- follow the readme"