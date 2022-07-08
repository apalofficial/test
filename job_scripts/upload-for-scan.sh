#!/bin/bash
set -exo pipefail
export JOB_ID=$(cat artifacts/job_id.txt)
echo "Scanning image for Job ID $JOB_ID"
mkdir /tmp/registry-certs
cp $TESTNET_KEY /tmp/registry-certs/user.key
cp $TESTNET_CERT /tmp/registry-certs/user.cert
skopeo copy --src-tls-verify=false --dest-tls-verify=false --src-cert-dir /tmp/registry-certs --dest-cert-dir /tmp/registry-certs docker://docker.akamai.com/build-images-development/basic_connector/image:0.1-$JOB_ID docker://staging.docker.akamai.com/xray-pilot-images/basic_connector/image:0.1-$JOB_ID
rm -rf /tmp/registry-certs
echo "Scan results will be located at https://staging.repos.akamai.com/ui/repos/tree/General/xray-pilot-images/basic_connector/image/0.1-$JOB_ID/manifest.json"
