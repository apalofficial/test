set -exo pipefail
echo "Deploying application..."

podman pull $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
REGISTRY_IMAGE="registry.linode.lol/basic_connector/image:0.1-$CI_JOB_ID"

podman tag $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA $REGISTRY_IMAGE
podman push $REGISTRY_IMAGE
mkdir artifacts
KUBECONFIG_DIR=$(dirname $K8S_KUBECONFIG)

podman run --rm --env KUBECONFIG=$K8S_KUBECONFIG -v $KUBECONFIG_DIR:$KUBECONFIG_DIR -v $PWD:/workspace --workdir /workspace docker.io/rancher/kubectl:v1.23.7 get deployment k8s-qa -o yaml --namespace gitlab > artifacts/qa-deployment.yaml

sed -i -- "s/\(- image: \).*/\1$REGISTRY_IMAGE/" artifacts/qa-deployment.yaml

podman run --rm --env KUBECONFIG=$K8S_KUBECONFIG -v $KUBECONFIG_DIR:$KUBECONFIG_DIR -v $PWD:/workspace --workdir /workspace docker.io/rancher/kubectl:v1.23.7 apply -f artifacts/qa-deployment.yaml