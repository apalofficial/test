#!/bin/bash
set -exo pipefail
echo "Deploying application..."
dnf -y install skopeo #required for image pull at non-standard port
#export JOB_ID=$(cat artifacts/job_id.txt)
export JOB_ID=9d9be53a-eaaf-11ec-ade4-0242c0a8080e
mkdir /tmp/registry-certs
cp $TESTNET_KEY /tmp/registry-certs/user.key
cp $TESTNET_CERT /tmp/registry-certs/user.cert
skopeo copy --src-tls-verify=false --src-cert-dir /tmp/registry-certs docker://staging.docker.akamai.com:5433/build-images-development/basic_connector/test:0.1-$JOB_ID containers-storage:staging.docker.akamai.com/build-images-development/basic_connector/test:0.1-$JOB_ID 
rm -rf /tmp/registry-certs
podman system connection add --identity $CI_DEPLOY_KEY hello-ci ssh://$PODMAN_USER@hello-ci.akamai.lol:22222/run/user/$PODMAN_UID/podman/podman.sock
podman image scp staging.docker.akamai.com/build-images-development/basic_connector/test:0.1-$JOB_ID hello-ci::
set +e
podman --remote stop ci
set -e
podman --remote run --rm --name ci -d --network=host staging.docker.akamai.com/build-images-development/basic_connector/test:0.1-$JOB_ID
podman --remote image prune -fa
