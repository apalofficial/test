set -exo pipefail
echo "Pushing image to k8s registry..."

podman tag $SOURCE_IMAGE $REGISTRY_IMAGE
podman push $REGISTRY_IMAGE