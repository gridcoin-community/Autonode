#!/bin/bash
echo "-=-=-=- The server will reboot when the script is complete -=-=-=-"
echo "-=-=-=- Changing to home dir -=-=-=-"
cd ~
echo "-=-=-=- Updating Debian -=-=-=-"
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:gridcoin/gridcoin-daily
sources="/etc/apt/sources.list.d/gridcoin-gridcoin-daily-jessie.list"
echo 'deb http://ppa.launchpad.net/gridcoin/gridcoin-stable/ubuntu trusty main' | sudo tee $sources
echo 'deb-src http://ppa.launchpad.net/gridcoin/gridcoin-stable/ubuntu trusty main' | sudo tee -a $sources
wget https://mirrors.kernel.org/ubuntu/pool/main/m/miniupnpc/libminiupnpc8_1.6-3ubuntu1.2_amd64.deb
sudo dpkg -i libminiupnpc8_1.6-3ubuntu1.2_amd64.deb
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install Gridcoinresearchd
sudo apt-get -y install unzip

echo "-=-=-=- Creating Swap -=-=-=-"
sudo su -c "dd if=/dev/zero of=/swapfile bs=1M count=2048 ; mkswap /swapfile ; swapon /swapfile"
echo '/swapfile swap swap defaults 0 0' | sudo tee -a /etc/fstab

echo "-=-=-=- Create Gridcoin User -=-=-=-"
sudo useradd -m gridcoin

echo "-=-=-=- Creating config-=-=-=-"
cd ~gridcoin
sudo -u gridcoin mkdir .GridcoinResearch
cd /home/gridcoin/.GridcoinResearch/
sudo -u gridcoin wget http://download.gridcoin.us/download/downloadstake/signed/snapshot.zip
sudo unzip snapshot.zip
sudo chown -R gridcoin:gridcoin /home/gridcoin/.GridcoinResearch/*
config="/home/gridcoin/.GridcoinResearch/gridcoinresearch.conf"
sudo -u gridcoin touch $config
echo "server=1" | sudo tee -a $config
echo "daemon=1" | sudo tee -a $config
echo "listen=1" | sudo tee -a $config
echo "addnode=grc.z9.de" | sudo tee -a $config
echo "addnode=node.gridcoin.us" | sudo tee -a $config
echo "addnode=gridcoin.asia" | sudo tee -a $config
echo "addnode=node1.chick3nman.com" | sudo tee -a $config
echo "addnode=grc.z9.de" | sudo tee -a $config
echo "addnode=typh00n.net" | sudo tee -a $config
echo "addnode=amsterdam.grcnode.co.uk" | sudo tee -a $config
echo "addnode=frankfurt.grcnode.co.uk" | sudo tee -a $config
echo "addnode=quebec.gridcoin.co.il" | sudo tee -a $config
echo "addnode=ils.gridcoin.co.il" | sudo tee -a $config
echo "addnode=node.gridcoinapp.xyz" | sudo tee -a $config
echo "addnode=grcnode01.centralus.cloudapp.azure.com" | sudo tee -a $config
echo "addnode=grcnode02.eastus.cloudapp.azure.com" | sudo tee -a $config
echo "addnode=grcnode03.westus.cloudapp.azure.com" | sudo tee -a $config
echo "addnode=oregon.grcnode.dopeshit.net" | sudo tee -a $config
echo "addnode=seattle.grcnode.deluxe-host.net" | sudo tee -a $config
echo "addnode=seattle.grcnode2.dopeshit.net" | sudo tee -a $config
echo "rpcport=9332" | sudo tee -a $config
randUser=`< /dev/urandom tr -dc A-Za-z0-9 | head -c128`
randPass=`< /dev/urandom tr -dc A-Za-z0-9 | head -c128`
echo "rpcuser=$randUser" | sudo tee -a $config
echo "rpcpassword=$randPass" | sudo tee -a $config

echo "-=-=-=- Setting up NTP -=-=-=-"
sudo apt-get -y install ntp
/etc/init.d/ntp start

echo "-=-=-=- Setting up autostart on boot -=-=-=-"
sudo echo '#!/bin/sh' | sudo tee /etc/init.d/grcboot.sh
sudo echo 'sudo -u gridcoin gridcoinresearchd -datadir=/home/gridcoin/.GridcoinResearch/' | sudo tee -a /etc/init.d/grcboot.sh
sudo echo 'exit 0' | sudo tee -a /etc/init.d/grcboot.sh
sudo chmod 755 /etc/init.d/grcboot.sh
sudo update-rc.d grcboot.sh defaults

echo "-=-=-=- Add an alias -=-=-=-"
echo "alias grc='sudo -u gridcoin gridcoinresearchd -datadir=/home/gridcoin/.GridcoinResearch/'" | sudo tee -a ~/.bashrc

sudo reboot +5
