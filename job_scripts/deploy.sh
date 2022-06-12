#!/bin/bash
set -exo pipefail
echo "Deploying application..."
dnf -y install skopeo #required for image pull at non-standard port
export JOB_ID=$(cat artifacts/job_id.txt)
# export JOB_ID=295004d8-ea58-11ec-a021-0242c0a8080e
mkdir /tmp/registry-certs
cp $TESTNET_KEY /tmp/registry-certs/user.key
cp $TESTNET_CERT /tmp/registry-certs/user.cert
skopeo copy --src-tls-verify=false --src-cert-dir /tmp/registry-certs docker://staging.docker.akamai.com:5433/build-images-development/basic_connector/test:0.1-$JOB_ID containers-storage:test:0.1-$JOB_ID
rm -rf /tmp/registry-certs
podman system connection add --identity $CI_DEPLOY_KEY hello-ci ssh://ci-user@hello-ci.akamai.lol:22222/run/user/1000/podman/podman.sock
podman image scp test:0.1-$JOB_ID hello-ci::
podman --remote stop ci || /bin/true
podman --remote run --rm --name ci -d --network=host test:0.1-$JOB_ID
podman --remote image prune -fa
echo "Latest deployment is at https://hello-ci.akamai.lol"