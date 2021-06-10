# 2021 - Nguyen Nhat Linh
# Tong hop khi tim hieu OpenedX

#!/bin/bash

MYSQLDBPASS=
SECRETKEY=
CLIENTID=
CLIENTSECRET=
#HOST=
#ELASTICSEARCHURL=
#DATASTORE=
#ALLOWHOST=

#/https?:\/\/(?:[-\w]+\.)?([-\w]+)\.\w+(?:\.\w+)?\/?.*/g

sed -i -e "s/.*EDX_NOTES_API_MYSQL_DB_PASS.*/EDX_NOTES_API_MYSQL_DB_PASS: $MYSQLDBPASS/" /edx/app/edx_ansible/edx_ansible/playbooks/roles/edx_notes_api/defaults/main.yml
sed -i -e "s/.*EDX_NOTES_API_SECRET_KEY.*/EDX_NOTES_API_SECRET_KEY: $SECRETKEY/" /edx/app/edx_ansible/edx_ansible/playbooks/roles/edx_notes_api/defaults/main.yml
sed -i -e "s/.*EDX_NOTES_API_CLIENT_ID.*/EDX_NOTES_API_CLIENT_ID: $CLIENTID/" /edx/app/edx_ansible/edx_ansible/playbooks/roles/edx_notes_api/defaults/main.yml
sed -i -e "s/.*EDX_NOTES_API_CLIENT_SECRET.*/EDX_NOTES_API_CLIENT_SECRET: $CLIENTSECRET/" /edx/app/edx_ansible/edx_ansible/playbooks/roles/edx_notes_api/defaults/main.yml
#sed -i -e "s/.*EDX_NOTES_API_MYSQL_HOST.*/EDX_NOTES_API_MYSQL_HOST: $HOST/" /edx/app/edx_ansible/edx_ansible/playbooks/roles/edx_notes_api/defaults/main.yml
#sed -i -e "s/.*EDX_NOTES_API_ELASTICSEARCH_URL.*/EDX_NOTES_API_ELASTICSEARCH_URL: $ELASTICSEARCHURL/" /edx/app/edx_ansible/edx_ansible/playbooks/roles/edx_notes_api/defaults/main.yml
#sed -i -e "s/.*EDX_NOTES_API_DATASTORE_NAME.*/EDX_NOTES_API_DATASTORE_NAME: $DATASTORE/" /edx/app/edx_ansible/edx_ansible/playbooks/roles/edx_notes_api/defaults/main.yml
#sed -i -e "s/.*EDX_NOTES_API_ALLOWED_HOST.*/EDX_NOTES_API_ALLOWED_HOST: $ALLOWHOST/" /edx/app/edx_ansible/edx_ansible/playbooks/roles/edx_notes_api/defaults/main.yml

sed -i -e "s/.*ENABLE_EDXNOTES.*/ENABLE_EDXNOTES: true/" /edx/etc/lms/yml
sed -i -e "s/.*EDXNOTES_INTERNAL_API.*/EDXNOTES_INTERNAL_API: "https://127.0.0.1/18120/api/v1"/" /edx/etc/lms.yml
sed -i -e "s/.*EDXNOTES_PUBLIC_API.*/EDXNOTES_PUBLIC_API: "https://127.0.0.1:18120/api/v1"/" /edx/etc/lms.yml
sed -i -e "s/.*JWT_ISSUER.*/JWT_ISSUER: "http://localhost/oauth2"/" /edx/etc/lms.yml

# Create user with Ansible
source /edx/app/edx_ansible/venvs/edx_ansible/bin/activate << EOF
cd /edx/app/edx_ansible/edx_ansible/playbooks
echo 1 | sudo -S ansible-playbook -i 'localhost,' -c local ./run_role.yml -e 'role=edxlocal' -e@roles/edx_notes_api/defaults/main.yml
exit
EOF

# Install Notes software with Ansible
source /edx/app/edx_ansible/venvs/edx_ansible/bin/activate << EOF
cd /edx/app/edx_ansible/edx_ansible/playbooks/edx-east
echo 1 | sudo -S ansible-playbook -i 'localhost,' -c local ./notes.yml -e@/edx/app/edx_ansible/server-vars.yml
exit
EOF

# Run Database Migrations
export EDXNOTES_CONFIG_ROOT=/edx/etc/
export DB_MIGRATION_USER=root
export DB_MIGRATION_PASS="QQQwerty!@#123"
/edx/bin/python.edx_notes_api/edx/bin/manage.edx_notes_api migrate --settings="notesserver.settings.yaml_config"