#!/bin/bash
apt install iw macchanger sudo libcurl4-openssl-dev curl libz-dev module-assistant libssl-dev libnl-genl-3-dev libnl-3-dev pkg-config libsqlite3-dev git hostapd dnsmasq curl -y
apt install make g++ libnl-3-dev libnl-genl-3-dev -y
apt-get install wpasupplicant -y
# Git vwifi
git clone https://github.com/Raizo62/vwifi
cd vwifi
make
make tools # To change the file mode bits of tools
sudo make install
cd ..

cd /root
wget -nH -r --no-parent http://10.0.2.2/certs

# Download hostapd files wget
cd /root
wget -nH -r --no-parent http://10.0.2.2/pskClient/

cd /root
wget -nH -r --no-parent http://10.0.2.2/mgtClient/

cd /root
wget -nH -r --no-parent http://10.0.2.2/openClient/

# Config autoStart
echo '#!/bin/sh -e

nohup /root/startClients.sh &

exit 0
' >>  /etc/rc.local
chmod 755 /etc/rc.local

cd /root
wget 10.0.2.2/startClients.sh
chmod +x /root/startClients.sh

wget 10.0.2.2/cronClients.sh
chmod +x /root/cronClients.sh

export PATH=$PATH:/sbin

#CRON
#line="*/10 * * * * sh /root/cronClients.sh"
#(crontab -u root -l; echo "$line" ) | crontab -u root -