#!/bin/bash
set -exo pipefail
echo "Pulling image from Artifactory..."
mkdir /tmp/registry-certs
cp $TESTNET_KEY /tmp/registry-certs/user.key
cp $TESTNET_CERT /tmp/registry-certs/user.cert
podman pull --tls-verify=false --cert-dir /tmp/registry-certs $SOURCE_IMAGE
rm -rf /tmp/registry-certs
