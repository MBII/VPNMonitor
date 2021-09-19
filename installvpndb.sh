#!/bin/bash
echo "please make sure you have already edited 'startvpnmonitor.sh' and 'credentials.txt' with required variables before starting this -- follow the readme"
echo "installing sqlite3 and screen"
sudo apt install sqlite3 screen
echo "creating database 'mb2db.sqlite'"
sqlite3 mb2db.sqlite "CREATE TABLE iplist (id INTEGER PRIMARY KEY AUTOINCREMENT, ip varchar(30), vpn int, date DATETIME DEFAULT CURRENT_TIMESTAMP);"
echo "finished creating database 'mb2db.sqlite'"
echo "you can now start the VPN monitor with ./startvpnmonitor.sh"
