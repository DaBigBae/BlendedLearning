#!/bin/bash

# cp logo png to default theme /edx/app/edxapp/edx-platform/lms/static/images
sed -i "s/.*ENABLE_SPECIAL_EXAMS.*/ENABLE_SPECIAL_EXAM: true/" /edx/etc/lms.yml
sed -i "s/.*ENABLE_SPECIAL_EXAMS.*/ENABLE_SPECIAL_EXAM: true/" /edx/etc/studio.yml
sed -i "s/.*ENABLE_OTHER_COURSE_SETTINGS.*/ENABLE_OTHER_COURSE_SETTINGS: true/" /edx/etc/studio.yml
sed -i "s/.*MILESTONES_APP.*/MILESTONES_APP: true/" /edx/etc/lms.yml
sed -i "s/.*MILESTONES_APP.*/MILESTONES_APP: true/" /edx/etc/studio.yml
sed -i "s/.*ENTRANCE_EXAMS.*/ENTRANCE_EXAMS: true/" /edx/etc/lms.yml
sed -i "s/.*ENTRANCE_EXAMS.*/ENTRANCE_EXAMS: true/" /edx/etc/studio.yml

# Run migrate database
sudo -H -u edxapp bash << EOF
source /edx/app/edxapp/edxapp_env
cd /edx/app/edxapp/edx-platform
python ./manage.py lms migrate
python ./manage.py cms migrate
exit
EOF

/edx/bin/supervisorctl restart lms
/edx/bin/supervisorctl restart cms
/edx/bin/supervisorctl restart edxapp_worker: