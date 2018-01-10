# To install:
# 1) copy script
# 2) cd ~
# 3) vim script.sh
# 4) press i to enter insert mode
# 5) paste
# 6) press Esc, then enter :x then press Enter to save and exit vim
# 7) chmod +x script.sh
# 8) ./script.sh
# 9) monitor the output from the script, in case it throws an error
# *) do not include your own node in the addnode config, it will cause the Neural Network to ban your node
#=========================================================================================================

#!/bin/bash
echo "-=-=-=- The server will reboot when the script is complete -=-=-=-"
echo "-=-=-=- Ensuring root directory -=-=-=-"
cd

echo "-=-=-=- Adding Google DNS -=-=-=-"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf

echo "-=-=-=- Updating Debian -=-=-=-"
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:gridcoin/gridcoin-stable
sources="/etc/apt/sources.list.d/gridcoin-gridcoin-stable-jessie.list"
echo 'deb http://ppa.launchpad.net/gridcoin/gridcoin-stable/ubuntu trusty main' | sudo tee $sources
echo 'deb-src http://ppa.launchpad.net/gridcoin/gridcoin-stable/ubuntu trusty main' | sudo tee -a $sources
wget https://mirrors.kernel.org/ubuntu/pool/main/m/miniupnpc/libminiupnpc8_1.6-3ubuntu1.2_amd64.deb
sudo dpkg -i libminiupnpc8_1.6-3ubuntu1.2_amd64.deb
sudo apt-get -y update&&sudo apt-get -y upgrade
sudo apt-get -y install gridcoinresearchd
sudo apt-get -y install unzip ntp

echo "-=-=-=- Creating Swap -=-=-=-"
sudo su -c "dd if=/dev/zero of=/swapfile bs=1M count=2048 ; mkswap /swapfile ; swapon /swapfile"
echo '/swapfile swap swap defaults 0 0' | sudo tee -a /etc/fstab

echo "-=-=-=- Setting up NTP -=-=-=-"
/etc/init.d/ntp start

echo "-=-=-=- Create Gridcoin User -=-=-=-"
sudo useradd -m gridcoin

echo "-=-=-=- Creating config-=-=-=-"
cd /home/gridcoin
sudo -u gridcoin mkdir .GridcoinResearch
cd /home/gridcoin/.GridcoinResearch/
sudo -u gridcoin wget https://download.gridcoin.us/download/downloadstake/signed/snapshot.zip&&sudo unzip snapshot.zip&&sudo rm snapshot.zip
sudo chown -R gridcoin:gridcoin /home/gridcoin/.GridcoinResearch/*
config="/home/gridcoin/.GridcoinResearch/gridcoinresearch.conf"
sudo -u gridcoin touch $config
echo "server=1" | sudo tee -a $config
echo "daemon=1" | sudo tee -a $config
echo "listen=1" | sudo tee -a $config
echo "addnode=grcnode.adf.lu" | sudo tee -a $config
echo "addnode=node.tahvok.com" | sudo tee -a $config
echo "addnode=grcnode01.centralus.cloudapp.azure.com" | sudo tee -a $config
echo "addnode=grcnode02.eastus.cloudapp.azure.com" | sudo tee -a $config
echo "addnode=grcnode03.eastus.cloudapp.azure.com" | sudo tee -a $config
echo "addnode=grcnode04.eastus.cloudapp.azure.com" | sudo tee -a $config
echo "addnode=grcnode05.westus2.cloudapp.azure.com" | sudo tee -a $config
echo "addnode=gridcoin.crypto.fans" | sudo tee -a $config
echo "addnode=ils.gridcoin.co.il" | sudo tee -a $config
echo "addnode=la.grcnode.co.uk" | sudo tee -a $config
echo "addnode=london.grcnode.co.uk" | sudo tee -a $config
echo "addnode=miami.grcnode.co.uk" | sudo tee -a $config
echo "addnode=newyork.gridcoin.blacknetserver.com" | sudo tee -a $config
echo "addnode=node.gridcoin.us" | sudo tee -a $config
echo "addnode=node1.gridcoin.xyz" | sudo tee -a $config
echo "addnode=node1.chick3nman.com" | sudo tee -a $config
echo "addnode=nuad.de" | sudo tee -a $config
echo "addnode=oregon.gridcoin.stablenode.net" | sudo tee -a $config
echo "addnode=quebec.gridcoin.co.il" | sudo tee -a $config
echo "addnode=seattle.grcnode.deluxe-host.net" | sudo tee -a $config
echo "addnode=seattle2.gridcoin.stablenode.net" | sudo tee -a $config
echo "addnode=singapore.grcnode.co.uk" | sudo tee -a $config
echo "addnode=toronto01.gridcoin.ifoggz-network.xzy" | sudo tee -a $config
echo "addnode=vancouver01.gridcoin.ifoggz-network.xzy" | sudo tee -a $config
echo "addnode=gridcoin.hopto.org" | sudo tee -a $config
echo "rpcport=9332" | sudo tee -a $config
echo "listen=1" | sudo tee -a $config
echo "poolmining=false" | sudo tee -a $config
echo "UpdatingLeaderboard=false" | sudo tee -a $config
echo "cpumining=false" | sudo tee -a $config
randUser=`< /dev/random tr -dc A-Za-z0-9 | head -c64`
randPass=`< /dev/random tr -dc A-Za-z0-9 | head -c64`
echo "rpcuser=$randUser" | sudo tee -a $config
echo "rpcpassword=$randPass" | sudo tee -a $config

echo "-=-=-=- Setting up autostart on boot -=-=-=-"
sudo echo '#!/bin/sh' | sudo tee /etc/init.d/grcboot.sh
sudo echo 'sudo -u gridcoin gridcoinresearchd -datadir=/home/gridcoin/.GridcoinResearch/' | sudo tee -a /etc/init.d/grcboot.sh
sudo echo 'exit 0' | sudo tee -a /etc/init.d/grcboot.sh
sudo chmod 755 /etc/init.d/grcboot.sh
sudo update-rc.d grcboot.sh defaults

echo "-=-=-=- Add an alias -=-=-=-"
echo "alias grc='sudo -u gridcoin gridcoinresearchd -datadir=/home/gridcoin/.GridcoinResearch/'" | sudo tee -a ~/.bashrc

sudo reboot +5
