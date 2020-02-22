#!/usr/bin/env bash

set -e

gcloud compute firewall-rules create allow-vanity-ports --allow tcp:30000-30100 --project bsides-workshop
