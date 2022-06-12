 #!/bin/bash
set -exo pipefail
export JOB_ID=$(cat artifacts/job_id.txt)
echo "Scanning image for Job ID $JOB_ID"
mkdir /tmp/registry-certs
cp $TESTNET_KEY /tmp/registry-certs/user.key
cp $TESTNET_CERT /tmp/registry-certs/user.cert
skopeo copy --src-tls-verify=false --dest-tls-verify=false --src-cert-dir /tmp/registry-certs --dest-cert-dir /tmp/registry-certs docker://staging.docker.akamai.com:5433/build-images-development/basic_connector/test:0.1-$JOB_ID docker://staging.docker.akamai.com:5433/xray-pilot-images/basic_connector/test:0.1-$JOB_ID
rm -rf /tmp/registry-certs
echo "Scan results will be located at https://staging.repos.akamai.com/ui/repos/tree/General/xray-pilot-images/basic_connector/test/0.1-$JOB_ID/manifest.json"
