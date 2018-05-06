#!/bin/bash

# this script must be run with root privileges

# update & install prerequisites
export DEBIAN_FRONTEND='noninteractive'
apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"
apt-get install -y --no-install-recommends software-properties-common apt-transport-https curl unzip

# add appropriate repo, update packages & install gridcoin daemon
dist=$(lsb_release -sc)
case $dist in
    jessie|stretch|buster)
            add-apt-repository -y "deb https://dl.bintray.com/gridcoin/deb $dist stable"
            apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 379CE192D401AB61
            apt-get update && apt-get install -y --no-install-recommends gridcoinresearchd ;;
    trusty|xenial|artful|bionic)
            add-apt-repository -y ppa:gridcoin/gridcoin-stable
            apt-get update && apt-get install -y --no-install-recommends gridcoinresearchd ;;
    *)
            echo "DISTRO NOT SUPPORTED" && exit ;;
esac

# create gridcoin user & directories
useradd -m gridcoin
runuser -l gridcoin -c 'mkdir /home/gridcoin/.GridcoinResearch'

# generate random rpc user and password for conf
randUser=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
randPass=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# create the gridcoinresearch.conf file
runuser -l gridcoin -c 'touch /home/gridcoin/.GridcoinResearch/gridcoinresearch.conf'
runuser -l gridcoin -c "cat <<EOT >> /home/gridcoin/.GridcoinResearch/gridcoinresearch.conf
server=1
daemon=1
rpcport=9332
listen=1
rpcuser=$randUser
rpcpassword=$randPass
addnode=grcnode.tahvok.com
addnode=grcexplorer.neuralminer.io
addnode=grcnode01.neuralminer.io
addnode=grcnode02.neuralminer.io
addnode=grcnode03.neuralminer.io
addnode=grcnode04.neuralminer.io
addnode=grcnode05.neuralminer.io
addnode=gridcoin.bunnyfeet.fi
addnode=gridcoin.certic.info
addnode=gridcoin.hopto.org
addnode=ils.gridcoin.co.il
addnode=node.gridcoin.network
addnode=node1.gridcoin.xyz
addnode=node1.chick3nman.com
addnode=quebec.gridcoin.co.il
EOT"

# pull official snapshot.
runuser -l gridcoin -c 'cd /home/gridcoin/.GridcoinResearch && if [ ! -f "snapshot.zip" ]; then curl -O https://download.gridcoin.us/download/downloadstake/signed/snapshot.zip; fi'
runuser -l gridcoin -c 'cd /home/gridcoin/.GridcoinResearch && unzip -o snapshot.zip'

#Create an alias.
echo "alias grc='sudo -u gridcoin gridcoinresearchd -datadir=/home/gridcoin/.GridcoinResearch/'" >> ~/.bashrc

# launch the daemon.
runuser -l gridcoin -c "gridcoinresearchd -datadir=/home/gridcoin/.GridcoinResearch/ &"