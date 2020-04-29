#!/usr/bin/env bash

set -eu

#
# This script sets up an environment for the exercises that follow.
# It follows the pattern used in the BSides workshop setup and will need to be
# modified before being used in other cases.
#
ZONE=us-west1-a
PROJECT=bsides-workshop

read -p "👤 Enter your assigned user number: " USER_NUMBER

if [ -z "${USER_NUMBER##*[!0-9]*}" ]; then
  echo "⚠️ User number must be numeric (got \"$USER_NUMBER\")"
  exit 1
fi

CLUSTER_NAME="workshop-$USER_NUMBER"

echo
echo "🔑 Authenticating to cluster \"$CLUSTER_NAME\" in project \"$PROJECT\" (zone \"$ZONE\")..."
gcloud container clusters get-credentials --zone "$ZONE" --project "$PROJECT" "$CLUSTER_NAME"

echo
echo "🤔 Checking that nodes are listable:"
kubectl get nodes

echo
echo "✅ kubectl is now configured to access your cluster."
