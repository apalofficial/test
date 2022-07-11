#!/bin/bash
set -exo pipefail
echo "Deploying application..."
podman system connection add --identity $CI_DEPLOY_KEY hello-ci ssh://$PODMAN_USER@hello-ci.akamai.lol:22222/run/user/$PODMAN_UID/podman/podman.sock
podman image scp $SOURCE_IMAGE hello-ci::
set +e
podman --remote stop ci
set -e
podman --remote run --rm --name ci -d --network=host $SOURCE_IMAGE
podman --remote image prune -fa
