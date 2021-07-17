#!/bin/bash

apt update

cp startHost.sh /root/
chmod +x /root/startHost.sh

declare -a arr=("startVM.sh" "restartVM.sh" "stopVM.sh")
for i in "${arr[@]}"
do
	chmod +x $i
	cp $i /root/
	chown user $i
	cp $i /home/user/
done

cp WifiLab.ova /home/user/
chown user /home/user/WifiLab.ova
# Install VBox guest additions
#apt install build-essential dkms linux-headers-$(uname -r) -y
#sh /media/cdrom/VBoxLinuxAdditions.run

# Install virtualbox
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
echo "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian bionic contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
sudo apt update
sudo apt install virtualbox-6.1 -y
#wget https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-10.10.0-amd64-netinst.iso
lechmod 777 debian-10.9.0-amd64-netinst.iso
mv debian-10.9.0-amd64-netinst.iso /home/user/

# Dependencies
apt install sudo iw macchanger aircrack-ng wireshark libcurl4-openssl-dev curl libz-dev module-assistant libssl-dev libnl-genl-3-dev libnl-3-dev pkg-config libsqlite3-dev git -y
apt install make g++ libnl-3-dev libnl-genl-3-dev -y
apt install sl sqlitebrowser net-tools -y
apt install hashcat -y
apt-get install wpasupplicant -y

# Git vwifi
git clone https://github.com/Raizo62/vwifi
cd vwifi
make
make tools # To change the file mode bits of tools
sudo make install
cd ..

# Config autoStart
echo '#!/bin/sh -e

nohup /root/startHost.sh &

exit 0
' >>  /etc/rc.local
chmod 755 /etc/rc.local

cd
wget https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt


# Certs TLS https://wiki.innovaphone.com/index.php?title=Howto:802.1X_EAP-TLS_With_FreeRadius

echo 'export PATH=$PATH:/sbin' >> ~/.bashrc

# 
usermod -aG sudo user

su -c 'xhost si:localuser:root' user

export PATH=$PATH:/sbin
#echo 'xhost si:localuser:root' >>  /home/user/.bashrc

systemctl stop lighttpd