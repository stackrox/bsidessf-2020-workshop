#!/usr/bin/env bash

set -e

for i in `seq 1 25`; do
  gcloud container clusters create "workshop-$i" \
  --project bsides-workshop \
  --enable-basic-auth \
  --enable-network-policy \
  --image-type UBUNTU \
  --no-enable-autoupgrade \
  --enable-stackdriver-kubernetes \
  --metadata disable-legacy-endpoints=false \
  --machine-type n1-standard-4 \
  --num-nodes 2 \
  --async \
  --zone us-west1-a
done
