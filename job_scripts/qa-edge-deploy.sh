#!/bin/bash
set -exo pipefail
echo "Scanning image for Job ID $CI_JOB_ID"
mkdir /tmp/registry-certs
cp $TESTNET_KEY /tmp/registry-certs/user.key
cp $TESTNET_CERT /tmp/registry-certs/user.cert
podman pull $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
REGISTRY_IMAGE="staging.docker.akamai.com/gitlab-edge-qa/basic_connector/image:0.1-$CI_JOB_ID"
podman tag $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA $REGISTRY_IMAGE
podman push --cert-dir /tmp/registry-certs --tls-verify=false $REGISTRY_IMAGE
rm -rf /tmp/registry-certs
echo "Image uploaded to $REGISTRY_IMAGE"