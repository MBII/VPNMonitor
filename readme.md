Created by Devon, rewritten for Movie Battles II by Spaghetti.

# Prerequisites

The scripts are intended for Linux and has been tested on Ubuntu 18 and 20. It will likely work elsewhere as long as the programs it uses are available.

# Installation

1. The monitor is dependent on server logging to take action, so make sure the following is set in the server's config:
    * ``seta g_log "logname.log"`` - Whatever you want to name it, should be unique per server instance if there are multiple. Logs are saved to ``~/.ja/MBII`` if using JAMPDed or ``~/.local/share/openjk/MBII`` if using an OpenJK dedicated server like MBIIDed.
    * ``seta g_logClientInfo "1"`` - To log client info.
    * ``seta g_logSync "1"`` - To write events to the logs as they happen.
2. Change to the directory where you want the script to be downloaded.
3. Run ``git clone https://github.com/MBII/VPNMonitor.git`` or manually download a ZIP of this repository and extract it.
4. Change to the VPNMonitor directory (or whatever you named it) and make all the scripts executable: ```chmod a+x *.sh```
5. Run ``./installvpndb.sh`` to install required programs and setup the database. User must have sudo privileges to install anything. Alternately just manually install ``screen`` and ``sqlite3`` then run the script without privileges to setup the database.
6. Open ``startvpnmonitor.sh``, ``stopvpnmonitor.sh``, and ``credentials.txt`` and edit the variable fields as necessary following the comments. Multiple servers can be monitored from the start and stop scripts.
7. Run ``./startvpnmonitor.sh`` to begin monitoring. You can view the screen using ``screen -r whatever_you_named_it``. Detach from the screen using ``CTRL + A`` then ``CTRL + D`` (if you just quit then it will stop the script too).
8. The script should continue working across server restarts, but you will at least want to add ``startvpnmonitor.sh`` to your regular automated start scripts to ensure it is running after the system restarts. ``stopvpnmonitor.sh`` can be used to stop all monitors.

# Management
If there is a false positive and you wish to unban someone, simply use ``rcon removeip`` as you would with any other regular ban. The monitor will not take action on any IP it has already checked, so the IP would not be banned again unless the entry is removed from mb2db.sqlite.
