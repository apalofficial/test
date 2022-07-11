set -exo pipefail
echo "Get, update, and apply k8s config..."

mkdir -p artifacts
KUBECONFIG_DIR=$(dirname $K8S_KUBECONFIG)

YAML_FILE="artifacts/$K8S_ENV-deployment.yaml"

podman run --rm --env KUBECONFIG=$K8S_KUBECONFIG -v $KUBECONFIG_DIR:$KUBECONFIG_DIR -v $PWD:/workspace --workdir /workspace docker.io/rancher/kubectl:v1.23.7 get deployment "k8s-$K8S_ENV" -o yaml --namespace gitlab > $YAML_FILE

sed -i -- "s;\(- image: \).*;\1$REGISTRY_IMAGE;" $YAML_FILE

podman run --rm --env KUBECONFIG=$K8S_KUBECONFIG -v $KUBECONFIG_DIR:$KUBECONFIG_DIR -v $PWD:/workspace --workdir /workspace docker.io/rancher/kubectl:v1.23.7 apply -f $YAML_FILE