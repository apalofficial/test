#!/bin/bash
set -exo pipefail
echo "Deploying application..."
dnf -y install skopeo #required for image pull at non-standard port
mkdir /tmp/registry-certs
cp $TESTNET_KEY /tmp/registry-certs/user.key
cp $TESTNET_CERT /tmp/registry-certs/user.cert
skopeo copy --src-tls-verify=false --src-cert-dir /tmp/registry-certs docker://docker.akamai.com/build-images-development/basic_connector/image:0.1-$JOB_ID containers-storage:docker.akamai.com/build-images-development/basic_connector/image:0.1-$JOB_ID 
rm -rf /tmp/registry-certs
