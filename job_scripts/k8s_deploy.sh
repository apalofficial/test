set -exo pipefail
echo "Pushing image to k8s registry..."

export REGISTRY_IMAGE="registry.linode.lol/basic_connector/image:0.1-$JOB_ID"

podman tag $SOURCE_IMAGE $REGISTRY_IMAGE
podman push $REGISTRY_IMAGE

jobs_scripts/k8s-config-apply.sh