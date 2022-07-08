set -exo pipefail
echo "Deploying application..."

podman pull $SOURCE_IMAGE
REGISTRY_IMAGE="registry.linode.lol/basic_connector/image:0.1-$JOB_ID"

podman tag $SOURCE_IMAGE $REGISTRY_IMAGE
podman push $REGISTRY_IMAGE
mkdir artifacts
KUBECONFIG_DIR=$(dirname $K8S_KUBECONFIG)

YAML_FILE="artifacts/$K8S_ENV-deployment.yaml"

podman run --rm --env KUBECONFIG=$K8S_KUBECONFIG -v $KUBECONFIG_DIR:$KUBECONFIG_DIR -v $PWD:/workspace --workdir /workspace docker.io/rancher/kubectl:v1.23.7 get deployment "k8s-$K8S_ENV" -o yaml --namespace gitlab > $YAML_FILE

sed -i -- "s;\(- image: \).*;\1$REGISTRY_IMAGE;" $YAML_FILE

podman run --rm --env KUBECONFIG=$K8S_KUBECONFIG -v $KUBECONFIG_DIR:$KUBECONFIG_DIR -v $PWD:/workspace --workdir /workspace docker.io/rancher/kubectl:v1.23.7 apply -f $YAML_FILE