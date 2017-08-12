GridcoinAutoNode
===============

A script to run (ideally just after starting up a new server/VPS) to automatically setup `gridcoinresearchd` under `gridcoin` user, and have it start on boot (Debian).

It has been tested on Ubuntu 14.04 and Debian 8 (Jessie), and is only intended for use on these distros.

One Liner - DO NOT run without reading code first!
--------------------------------------------------
Ubuntu 14.04

    wget https://raw.githubusercontent.com/gridcoin-community/Autonode/GridcoinAutoNode.sh ; sudo bash GridcoinAutoNode.sh
Debian  

    wget https://raw.githubusercontent.com/gridcoin-community/Autonode/master/GridcoinAutoNodeDebian.sh ; sudo bash GridcoinAutoNodeDebian.sh

Notes
-----

This script installs:
- chrony
- git
- make
- gcc
- unzip
- apt-utils
- software-properties-common
- sudo
- gridcoinresearchd (manually compiled from source)
- libminiupnpc8 (Debian)
- curl
- build-essential
- libssl-dev
- libdb-dev
- libdb++-dev
- libqrencode-dev
- libcurl4-openssl-dev
- libzip-dev
- libzip2/libzip4
- libboost1.55-all-dev

This script:
- Creates a 'gridcoin' user to run gridcoinresearchd under (safer than running client as root)
- Downloads snapshot instead of syncing from block 0 (edit script if you don't want it to do this)
- Adds Google DNS to ensure package manager is reachable
- Adds Spideroak as a host for snapshot download
- Configures chrony (be sure to update timezone if you care about that sort of thing)
- Autostart when done (Ubuntu)
- Autostart on boot (Debian)
