#!/bin/bash

if [ "$SKIP_JOB" == true ]; then
    echo "Skipping Job"
    exit
fi

cd dartstream || exit 

tar -czf dartstream.tgz ./*

gcloud builds submit dartstream.tgz \
  --tag us-central1-docker.pkg.dev/dartstream-dev/dartstream-dev/dartstream-dev1:"$CI_COMMIT_REF_SLUG"

gcloud run deploy dartstream-dev1 \
  --image us-central1-docker.pkg.dev/dartstream-dev/dartstream-dev/dartstream-dev1:"$CI_COMMIT_REF_SLUG" \
  --region us-central1 \
  --service-account vcf-dev-cloud-cd@dartstream-dev.iam.gserviceaccount.com