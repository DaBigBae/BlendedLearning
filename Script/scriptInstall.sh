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

cat << EOF > config.yml
EDXAPP_PLATFORM_NAME: 'CITD EDU Online'
EDXAPP_PLATFORM_DESCRIPTION: 'Center for Information Technology Development'

EDXAPP_LMS_BASE: "localhost:80"
EDXAPP_CMS_BASE: "localhost:18010"
EOF


echo -e "****************************************\n"
echo ">>> Bootstrap the Ansible installation"
echo -e "\n****************************************"
wget https://raw.githubusercontent.com/edx/configuration/$OPENEDX_RELEASE/util/install/ansible-bootstrap.sh -O - | sudo -E bash

echo -e "****************************************\n"
echo ">>> Randomize password. Please keep it in safe place"
echo -e "\n****************************************"
wget https://raw.githubusercontent.com/edx/configuration/$OPENEDX_RELEASE/util/install/generate-passwords.sh -O - | bash

echo -e "****************************************\n"
echo ">>> Install the Open edX software"
echo -e "\n****************************************"
wget https://raw.githubusercontent.com/edx/configuration/$OPENEDX_RELEASE/util/install/native.sh -O - | bash