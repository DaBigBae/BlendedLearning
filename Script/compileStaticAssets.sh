#!/bin/bash

# cp logo png to default theme /edx/app/edxapp/edx-platform/lms/static/images
#sed -i "s/.*ENABLE_COMPREHENSIVE_THEMING\W.*/ENABLE_COMPREHENSIVE_THEMING: true/" /edx/etc/lms.yml

sudo -H -u edxapp bash << EOF
source /edx/app/edxapp/edxapp_env
cd /edx/app/edxapp/edx-platform
paver update_assets lms --settings=production
paver update_assets cms --settings=production
EOF

/edx/bin/supervisorctl restart lms
/edx/bin/supervisorctl restart cms
/edx/bin/supervisorctl restart edxapp_worker: