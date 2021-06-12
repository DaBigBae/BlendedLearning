# 2021 - Nguyen Nhat Linh
# Tong hop khi tim hieu OpenedX

#!/bin/bash

echo -e "****************************************\n"
echo ">>> Grant permissioons"
echo -e "\n****************************************"
chmod 755 ./*.sh

echo -e "****************************************\n"
echo ">>> Install some package"
echo -e "\n****************************************"
apt install -y locales openssh-server

echo -e "****************************************\n"
echo ">>> Set Terminal output"
echo -e "\n****************************************"
locate-gen en_US en_US.UTF-8
dpkg-reconfigure --frontend noninteractive locales
dpkg --configure -a

echo -e "****************************************\n"
echo ">>> Updating  your server"
echo -e "\n****************************************"
apt update -y
apt upgrade -y

echo -e "****************************************\n"
echo ">>> Setup firewall"
echo -e "\n****************************************"
ufw allow ssh
ufw allow 80
ufw allow 443
ufw allow 8000:8999/tcp
ufw allow 18000:18999/tcp
ufw enable

echo -e "\n>>> All done! You need to reboot your server."
echo "After reboot, you need to run < scriptInstall.sh > under root privilege."
echo "Type: < sudo reboot >, to reboot your server."
