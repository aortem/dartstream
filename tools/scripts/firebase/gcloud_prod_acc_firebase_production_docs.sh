#!/bin/bash

set -e # Exit immediately if any command fails

echo "Navigating to Docs directory"
cd dartstream/docs

echo "Listing files in the directory"
ls -la

echo "Cleaning up previous artifacts"
rm -rf node_modules dist

echo "Installing dependencies"
npm ci
 
echo "Building the project"
npm run build

echo "Current project: $(gcloud config get-value project)"

gcloud auth activate-service-account $ACCOUNT_PROD --key-file=$GOOGLE_CLOUD_CREDENTIALS_PROD

echo "Setting account to: $ACCOUNT_PROD"
gcloud config set account $ACCOUNT_PROD

echo "Authenticated accounts:"
gcloud auth list

gcloud config set project dartstream-open-dev

# Verify the configuration
echo "Active account: $(gcloud config get-value account)"
echo "Active project: $(gcloud config get-value project)"

echo "Current directory: $(pwd)"
ls -la

# # Navigate back to the frontend root
# echo "Navigating to frontend directory for Firebase Docs deployment"
# cd ..

# echo "Current directory: $(pwd)"
# ls -la

export GOOGLE_APPLICATION_CREDENTIALS="$GOOGLE_APPLICATION_CREDENTIALS_PROD"

gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS_PROD
gcloud config set project dartstream-open-dev

echo "Installing Firebase CLI globally"
npm install -g firebase-tools

echo "Listing available Firebase projects"
firebase projects:list

# Add the desired Firebase project to the local configuration
echo "Adding Firebase project to local configuration"
firebase use --add dartstream-open-dev || echo "Project already configured"

# Deploy to Firebase
# echo "Deploying to Firebase Hosting"
# firebase deploy --project aortem-prod

# npm For Vite production assets
#which npm
#echo $PATH
#apk add nodejs npm
#cd aortem || exit
#npm i vite 
#npm run prod