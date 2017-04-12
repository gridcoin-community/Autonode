GridcoinAutoNode
===============

A script to run (ideally just after starting up a new server/VPS) to automatically setup `gridcoinresearchd` under `gridcoin` user, and have it start on boot (Debian).

It has been tested on Ubuntu 14.04 and Debian 8 (Jessie), and is only intended for use on these distros.

One Liner - DO NOT run without reading code first!
--------------------------------------------------
Ubuntu

    wget https://raw.githubusercontent.com/gridcoin-community/Autonode/GridcoinAutoNode.sh ; sudo bash GridcoinAutoNode.sh
Debian  

    wget https://raw.githubusercontent.com/gridcoin-community/Autonode/master/GridcoinAutoNodeDebian.sh ; sudo bash GridcoinAutoNodeDebian.sh

Notes
-----

This script installs:
- NTP/chrony
- git (autoremoved after completion)
- make (autoremoved after completion)
- gcc (autoremoved after completion)
- unzip (autoremoved after completion)
- apt-utils
- software-properties-common
- sudo
- gridcoinresearchd (from ppa:gridcoin/gridcoin-stable, not manually compiled from source)
- libminiupnpc8 (Debian)

This script:
- Includes an option to disable IPv6 (uncomment first section if you require only IPv4)
- Creates a 'gridcoin' user to run gridcoinresearchd under (safer than running client as root)
- Downloads official bootstrap instead of syncing from block 0 (edit script if you don't want it to do this)
- Adds Google DNS
- Ensures Spideroak is reachable for updates
- Configures NTP/chrony
- Cleans up after itself by removing packages after install (git, gcc, make, unzip)
- Autostart on boot (Debian)
