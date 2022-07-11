#!/bin/bash
set -exo pipefail
echo "Pushing image to Artifactory repo for distribution to edge"
mkdir /tmp/registry-certs
cp $TESTNET_KEY /tmp/registry-certs/user.key
cp $TESTNET_CERT /tmp/registry-certs/user.cert
REGISTRY_IMAGE="staging.docker.akamai.com/gitlab-edge-$K8S_ENV/basic_connector/image:0.1-$JOB_ID"
podman tag $SOURCE_IMAGE $REGISTRY_IMAGE
podman push --cert-dir /tmp/registry-certs --tls-verify=false $REGISTRY_IMAGE
rm -rf /tmp/registry-certs
echo "Image uploaded to $REGISTRY_IMAGE"