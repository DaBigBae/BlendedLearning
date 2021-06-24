#!/usr/bin/env bash
set -eu -o pipefail
set -x

#This script depends on the LMS being up!

app_name=$1
client_name=$2
client_port=$3
user_name=$4

echo -e "Creating service user and OAuth2 applications for ${app_name}..."

echo ""$app_name" "$client_name" "$client_port""
# Create the service user.
source /edx/app/edxapp/edxapp_env && python /edx/app/edxapp/edx-platform/manage.py lms --settings=production manage_user $4_worker $4_worker@example.com --staff --superuser --unusable-password


# Create the DOT applications - one for single sign-on and one for backend service IDA-to-IDA authentication.
source /edx/app/edxapp/edxapp_env && python /edx/app/edxapp/edx-platform/manage.py lms --settings=production create_dot_application --grant-type authorization-code --skip-authorization --redirect-uris "http://localhost:$3/complete/edx-oauth2/" --client-id "$1-sso-key" --client-secret "$1-sso-secret" --scopes "user_id" $1 $1_worker
source /edx/app/edxapp/edxapp_env && python /edx/app/edxapp/edx-platform/manage.py lms --settings=production create_dot_application --grant-type client-credentials --client-id "$1-backend-service-key" --client-secret "$1-backend-service-secret" $1-backend-service $1_worker