#!/bin/bash
echo "########### The server will reboot when the script is complete"
echo "########### Changing to /home/ dir"
cd ~

# echo "########### Disabling IPv6"
# sed -i '$anet.ipv6.conf.all.disable_ipv6 = 1' /etc/sysctl.conf
# sed -i '$anet.ipv6.conf.default.disable_ipv6 = 1' /etc/sysctl.conf
# sed -i '$anet.ipv6.conf.lo.disable_ipv6 = 1' /etc/sysctl.conf
# sysctl -p

echo "########### Adding Google DNS"
sed -i '$a\        dns-nameservers 8.8.8.8 8.8.4.4' /etc/network/interfaces

echo "########### Adding Spideroak source"
echo "38.121.104.79 spideroak.com" >> /etc/hosts

echo "########### Installing necessary packages"
apt-get -y dist-upgrade
apt-get -y update && apt-get -y upgrade; apt-get install -y --no-install-recommends apt-utils && apt-get -y install software-properties-common && apt-get -y install sudo && apt-get -y install git && apt-get -y install gcc && apt-get -y install make && apt-get -y install unzip
add-apt-repository -y ppa:gridcoin/gridcoin-stable
apt-get -y update && apt-get -y upgrade; apt-get -y install gridcoinresearchd

echo "########### Creating gridcoin user"
useradd -m gridcoin

echo "########### Creating gridcoinresearch.conf file"
cd ~gridcoin
sudo -u gridcoin mkdir .GridcoinResearch
cd /home/gridcoin/.GridcoinResearch/

#echo "########### Downloading and extracting bootstrap.zip"
#sudo -u gridcoin wget https://spideroak.com/share/N4YFAZLQOBSXEMDP/public/d%3A/Gridcoin.Tools/Share/bootstrap.zip
#sudo unzip bootstrap.zip

#Official snapshot
sudo -u gridcoin wget https://download.gridcoin.us/download/downloadstake/signed/snapshot.zip
sudo unzip snapshot.zip
rm -rf snapshot.zip

sudo chown -R gridcoin:gridcoin /home/gridcoin/.GridcoinResearch/*
config="gridcoinresearch.conf"
sudo -u gridcoin touch $config
echo "server=1" > $config
echo "daemon=1" >> $config
echo "rpcport=9332" >> $config
echo "listen=1" >> $config
echo "suppressupgrade=false" >> $config
echo "suppressvoice=true" >> $config
echo "enablespeech=false" >> $config
echo "poolmining=false" >> $config
echo "UpdatingLeaderboard=false" >> $config
echo "cpumining=false" >> $config
echo "addnode=grcnode.adf.lu" | sudo tee -a $config
echo "addnode=node.tahvok.com" | sudo tee -a $config
echo "addnode=grcnode01.centralus.cloudapp.azure.com" | sudo tee -a $config
echo "addnode=grcnode02.eastus.cloudapp.azure.com" | sudo tee -a $config
echo "addnode=grcnode03.eastus.cloudapp.azure.com" | sudo tee -a $config
echo "addnode=grcnode04.eastus.cloudapp.azure.com" | sudo tee -a $config
echo "addnode=grcnode05.eastus.cloudapp.azure.com" | sudo tee -a $config
echo "addnode=gridcoin.asia" | sudo tee -a $config
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

randUser=`< /dev/random tr -dc A-Za-z0-9 | head -c64`
randPass=`< /dev/random tr -dc A-Za-z0-9 | head -c64`
echo "rpcuser=$randUser" >> $config
echo "rpcpassword=$randPass" >> $config

echo "########### Setting up chrony"
cd ~
git clone git://git.tuxfamily.org/gitroot/chrony/chrony.git
cd ~/chrony
./configure

echo "########### Cleaning up unnecessary packages"
apt-get -y remove git && apt-get -y remove gcc && apt-get -y remove make && apt-get -y remove unzip
apt-get -y autoremove

echo "########### All done! Thank you for supporting the Gridcoin network! Server will now start."
su - gridcoin -c gridcoinresearchd
