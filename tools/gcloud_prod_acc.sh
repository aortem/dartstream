#!/bin/bash

#cat "$woa_dev_service_creds" >"$(pwd)/service-account.json"

gcloud config set project dartstream-prod

gcloud auth activate-service-account $ACCOUNT_PROD --key-file $GOOGLE_CLOUD_CREDENTIALS_PROD

#gcloud auth activate-service-account --impersonate-service-account \
#  vs-dev-cloud-cd@dartstream-website-dev.iam.gserviceaccount.com

#gcloud config set auth/impersonate_service_account \
#  vs-dev-cloud-cd@dartstream-website-dev.iam.gserviceaccount.com

#gcloud auth print-access-token --impersonate-service-account \
#  vs-dev-cloud-cd@dartstream-website-dev.iam.gserviceaccount.com

#gcloud config unset auth/impersonate_service_account
#

# npm For Vite production assets
which npm
echo $PATH
apk add nodejs npm
cd dartstream || exit
npm i vite 
npm run prod