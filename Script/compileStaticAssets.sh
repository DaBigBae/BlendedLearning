#!/bin/bash

# cp logo png to default theme /edx/app/edxapp/edx-platform/lms/static/images

sudo -H -u edxapp bash << EOF
source /edx/app/edxapp/edxapp_env
cd /edx/app/edxapp/edx-platform
paver update_assets lms --settings=production
paver update_assets cms --settings=production
EOF

./restartPlatform.sh -a