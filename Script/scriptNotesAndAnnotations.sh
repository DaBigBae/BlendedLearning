# 2021 - Nguyen Nhat Linh
# Tong hop khi tim hieu OpenedX

#!/bin/bash

MYSQLDBPASS="edXNotesAPIdbPass"
SECRETKEY="edXNotesAPISeccret"
CLIENTID="edx-notes-sso-key"
CLIENTSECRET="edx-notes-sso-secret"
#COMMON_MYSQL_ADMIN_PASS in /root/my-password.yml
DBMIGRATIONPASS=
#HOST="localhost"
#ELASTICSEARCHURL="localhost:9200"
#DATASTORE= (đã có tham chiếu - edx_notes_api)
#ALLOWHOST= (nếu có địa chỉ web khi triển khai production, nên thêm host vào)

show_help(){
    echo "
Usage: scriptNotesAndAnnotation.sh [-p MySQLDBPassword] [-k SecretKey]
             [-i ClientID] [-s ClientSecret] [-d DBAdminPassword] [-h] args

Main options:
    -p Set password for Notes DB
    -k Secret key of Notes API
    -i Client ID of OAuth
    -s Client secret of OAuth
    -d DB Admin password

For example: ./scriptNotesAndAnnotation.sh -p MySQLDBPassword -k SecretKey -i 'client_id' -s clinetsecrret -d DBpassword

Help option:
    -h  Help
    "
    exit 0
}

main(){
    sed -i -e "s/EDX_NOTES_API_MYSQL_DB_PASS:.*/EDX_NOTES_API_MYSQL_DB_PASS: \"$MYSQLDBPASS\"/" /edx/app/edx_ansible/edx_ansible/playbooks/roles/edx_notes_api/defaults/main.yml
    sed -i -e "s/EDX_NOTES_API_SECRET_KEY:.*/EDX_NOTES_API_SECRET_KEY: \"$SECRETKEY\"/" /edx/app/edx_ansible/edx_ansible/playbooks/roles/edx_notes_api/defaults/main.yml
    sed -i -e "s/EDX_NOTES_API_CLIENT_ID:.*/EDX_NOTES_API_CLIENT_ID: \"$CLIENTID\"/" /edx/app/edx_ansible/edx_ansible/playbooks/roles/edx_notes_api/defaults/main.yml
    sed -i -e "s/EDX_NOTES_API_CLIENT_SECRET:.*/EDX_NOTES_API_CLIENT_SECRET: \"$CLIENTSECRET\"/" /edx/app/edx_ansible/edx_ansible/playbooks/roles/edx_notes_api/defaults/main.yml
    #sed -i -e "s/EDX_NOTES_API_MYSQL_HOST.*/EDX_NOTES_API_MYSQL_HOST: $HOST/" /edx/app/edx_ansible/edx_ansible/playbooks/roles/edx_notes_api/defaults/main.yml
    #sed -i -e "s/EDX_NOTES_API_ELASTICSEARCH_URL.*/EDX_NOTES_API_ELASTICSEARCH_URL: $ELASTICSEARCHURL/" /edx/app/edx_ansible/edx_ansible/playbooks/roles/edx_notes_api/defaults/main.yml
    #sed -i -e "s/EDX_NOTES_API_DATASTORE_NAME.*/EDX_NOTES_API_DATASTORE_NAME: $DATASTORE/" /edx/app/edx_ansible/edx_ansible/playbooks/roles/edx_notes_api/defaults/main.yml
    #sed -i -e "s/EDX_NOTES_API_ALLOWED_HOST/EDX_NOTES_API_ALLOWED_HOST:\n\t$ALLOWHOST/" /edx/app/edx_ansible/edx_ansible/playbooks/roles/edx_notes_api/defaults/main.yml
    sed -i -e "s/ENABLE_EDXNOTES:.*/ENABLE_EDXNOTES: true/" /edx/etc/lms.yml
    sed -i -e "s/ENABLE_EDXNOTES:.*/ENABLE_EDXNOTES: true/" /edx/etc/studio.yml
    #sed -i -e "s/EDXNOTES_INTERNAL_API.*/EDXNOTES_INTERNAL_API: "https://127.0.0.1:18120/api/v1"/" /edx/etc/lms.yml
    #sed -i -e "s/EDXNOTES_PUBLIC_API.*/EDXNOTES_PUBLIC_API: "https://127.0.0.1:18120/api/v1"/" /edx/etc/lms.yml
    #sed -i -e "s/JWT_ISSUER.*/JWT_ISSUER: "http://localhost/oauth2"/" /edx/etc/lms.yml
    #sed -i -e "s/JWT_ISSUER.*/JWT_ISSUER: "http://localhost/oauth2"/" /edx/etc/lms.yml
    #sed -i -e "s/JWT_ISSUER.*/JWT_ISSUER: "http://localhost/oauth2"/" /edx/etc/lms.yml
    # Comment role aws in roles
    sed -i -e "s/- role: aws/#- role: aws/" /edx/app/edx_ansible/edx_ansible/playbooks/notes.yml
    sed -i -e "s/when: COMMON_ENABLE_AWS_ROLE/# when: COMMON_ENABLE_AWS_ROLE/" /edx/app/edx_ansible/edx_ansible/playbooks/notes.yml
    
    # Create user and install Notes software with Ansible
source /edx/app/edx_ansible/venvs/edx_ansible/bin/activate &&\
cd /edx/app/edx_ansible/edx_ansible/playbooks &&\
sudo ansible-playbook -i 'localhost,' -c local ./run_role.yml -e 'role=edxlocal' -e@roles/edx_notes_api/defaults/main.yml
source /edx/app/edx_ansible/venvs/edx_ansible/bin/activate &&\
cd /edx/app/edx_ansible/edx_ansible/playbooks &&\
sudo ansible-playbook -i 'localhost,' -c local ./run_role.yml -e 'role=nginx' -e 'nginx_sites=edx_notes_api' -e@roles/edx_notes_api/defaults/main.yml
source /edx/app/edx_ansible/venvs/edx_ansible/bin/activate &&\
cd /edx/app/edx_ansible/edx_ansible/playbooks &&\
sudo ansible-playbook -i 'localhost,' -c local ./run_role.yml -e 'role=edx_notes_api' -e@roles/edx_notes_api/defaults/main.yml
source /edx/app/edx_ansible/venvs/edx_ansible/bin/activate &&\
cd /edx/app/edx_ansible/edx_ansible/playbooks/edx-east &&\
sudo ansible-playbook -i 'localhost,' -c local ./notes.yml
#
# sudo su
#   # Run Database Migrations in root
#    export EDXNOTES_CONFIG_ROOT=/edx/etc/
#    export DB_MIGRATION_USER=root
#    export DB_MIGRATION_PASS=${DBMIGRATIONPASS}
#    ln -s /edx/app/edx_notes_api/venvs/edx_notes_api/bin/python3.8 /edx/bin/python.edx_notes_api
#    /edx/bin/python.edx_notes_api /edx/bin/manage.edx_notes_api migrate --settings="notesserver.settings.yaml_config"
#
#    sudo -H -u edxapp bash << EOF
#source /edx/app/edxapp/edxapp_env
#cd /edx/app/edxapp/edx-platform
#paver update_assets cms --settings production
#paver update_assets lms --settings production
#exit
#EOF
# restatr platform
}

if (! getopts :p:k:i:s:d:h flag);
then
#dat cau hoi neu nhap y thi thuc hien cai dat mac dinh, neu khong show help
    main
    #show_help
fi

while getopts :p:k:i:s:d:h flag
do
    case "$flag" in
        p) #MySQLDBPassword
            MYSQLDBPASS=$OPTARG
        ;;
        k) #SecretKey
            SECRETKEY=$OPTARG
        ;;
        i) #OAuth ClientID
            CLIENTID=$OPTARG
        ;;
        s) #OAuth ClientSecret
            CLIENTSECRET=$OPTARG
        ;;
        d) #DB admin pass
            DB_MIGRATION_PASS=$OPTARG
        ;;
        h) #help
            show_help
        ;;
        *)
            echo "Invalid option: -$OPTARG. USE -h flag for help."
            exit 0
        ;;
    esac
done

#if [[ -n "$MYSQLDBPASS" && -n "$SECRETKEY" && -n "$CLIENTID" && -n "$CLIENTSECRET" && -n "$DBMIGRATIONPASS" ]];
#if [[ true ]];
#then
#    main
#else
#    echo "Please use -h flag for help!"
#    echo
#    show_help
#fi