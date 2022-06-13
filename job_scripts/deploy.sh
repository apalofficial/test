#!/bin/bash
set -exo pipefail
echo "Deploying application..."
export JOB_ID=$(cat artifacts/job_id.txt)
podman system connection add --identity $CI_DEPLOY_KEY hello-ci ssh://$PODMAN_USER@hello-ci.akamai.lol:22222/run/user/$PODMAN_UID/podman/podman.sock
podman image scp staging.docker.akamai.com/build-images-development/basic_connector/$IMAGE:0.1-$JOB_ID hello-ci::
set +e
podman --remote stop ci
set -e
podman --remote run --rm --name ci -d --network=host staging.docker.akamai.com/build-images-development/basic_connector/$IMAGE:0.1-$JOB_ID
podman --remote image prune -fa
