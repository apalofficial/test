#!/bin/bash
set -exo pipefail
echo "Pulling image..."
mkdir /tmp/registry-certs
cp $TESTNET_KEY /tmp/registry-certs/user.key
cp $TESTNET_CERT /tmp/registry-certs/user.cert
podman pull --tls-verify=false --cert-dir /tmp/registry-certs docker.akamai.com/build-images-development/basic_connector/image:0.1-$JOB_ID
rm -rf /tmp/registry-certs
