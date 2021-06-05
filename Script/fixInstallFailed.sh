# 2021 - Nguyen Nhat Linh
# Tong hop khi tim hieu OpenedX

#!/bin/bash

cd ~
echo -e "****************************************\n"
echo ">>> Init environment"
echo -e "\n****************************************"

export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export OPENEDX_RELEASE=open-release/koa.master
 
echo -e "****************************************\n"
echo ">>> Install the Open edX software"
echo -e "\n****************************************"
wget https://raw.githubusercontent.com/edx/configuration/$OPENEDX_RELEASE/util/install/native.sh -O - | bash

