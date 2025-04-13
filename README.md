
# Helm Chart for Java Web App

This Helm chart deploys a Java web application on a Kubernetes cluster, including configurations for deployment, service, and ingress.

## Prerequisites

- Kubernetes cluster
- Helm 3.x
- Docker image of the application in a container registry
- Configured `kubectl` and `helm` with access to the Kubernetes cluster

## Installation

### 1. Clone the Repository

```bash
git clone <repository-url>
cd <repository>/helm-charts/java-web-app
```

### 2. Customize Values

Edit the `values.yaml` file to set the required parameters:

```yaml
image:
    repository: "<docker-repository-url>"
    tag: "<image-tag>"
    pullPolicy: IfNotPresent

service:
    type: ClusterIP
    port: 8080

ingress:
    enabled: false
    annotations: {}
    hosts:
        - host: example.com
            paths:
                - path: /
                    pathType: ImplementationSpecific
    tls: []
```

### 3. Install the Chart

To install the chart with the release name `java-web-app`:

```bash
helm upgrade --install java-web-app ./ \
    --namespace my-namespace \
    --create-namespace \
    --set image.repository=<docker-repository-url> \
    --set image.tag=<image-tag>
```

Replace `<docker-repository-url>` and `<image-tag>` with the correct values for your Docker image.

## Configuration

### Default Values

The chart uses the following default values, which can be overridden using the `--set` flag or by modifying the `values.yaml` file:

```yaml
replicaCount: 1

image:
    repository: "nginx"
    tag: "latest"
    pullPolicy: IfNotPresent

service:
    type: ClusterIP
    port: 8080

ingress:
    enabled: false
    annotations: {}
    hosts: []
    tls: []

resources: {}

autoScaling:
    enabled: false
    minReplicas: 1
    maxReplicas: 10
    targetCPUUtilizationPercentage: 80

nodeSelector: {}

tolerations: []

affinity: {}
```

### Customize Using `values.yaml`

Modify `values.yaml` to customize:

- **`image.repository`**: URL of the Docker image.
- **`image.tag`**: Docker image tag.
- **`replicaCount`**: Number of replicas to deploy.
- **`service`**: Service type and port.
- **`ingress`**: Enable/disable ingress and configure hosts.
- **`resources`**: Set CPU/memory resource limits and requests.

## Verify Deployment

After installing the chart, verify the deployment:

### Check Pods

```bash
kubectl get pods -n my-namespace
```

### Check Services

```bash
kubectl get svc -n my-namespace
```

### Check Ingress (if enabled)

```bash
kubectl get ingress -n my-namespace
```

## Uninstalling the Chart

To uninstall the `java-web-app` release:

```bash
helm uninstall java-web-app -n my-namespace
```


## Makefile

A `Makefile` can be used to automate the deployment process of the Helm chart. Below is an example `Makefile` for this Helm chart:

```makefile
# Variables
NAMESPACE ?= my-namespace
RELEASE_NAME ?= java-web-app
CHART_DIR ?= ./helm-charts/java-web-app
DOCKER_REPOSITORY ?= <docker-repository-url>
IMAGE_TAG ?= <image-tag>

# Default target
.PHONY: all
all: install

# Install the Helm chart
.PHONY: install
install:
    helm upgrade --install $(RELEASE_NAME) $(CHART_DIR) \
        --namespace $(NAMESPACE) \
        --create-namespace \
        --set image.repository=$(DOCKER_REPOSITORY) \
        --set image.tag=$(IMAGE_TAG)

# Uninstall the Helm chart
.PHONY: uninstall
uninstall:
    helm uninstall $(RELEASE_NAME) -n $(NAMESPACE)

# Verify the deployment
.PHONY: verify
verify:
    kubectl get pods -n $(NAMESPACE)
    kubectl get svc -n $(NAMESPACE)
    kubectl get ingress -n $(NAMESPACE)

# Clean up
.PHONY: clean
clean: uninstall
    kubectl delete namespace $(NAMESPACE)
```

### Usage

1. **Install the Chart**: Run `make install` to install the Helm chart.
2. **Uninstall the Chart**: Run `make uninstall` to uninstall the Helm chart.
3. **Verify Deployment**: Run `make verify` to check the status of the deployment.
4. **Clean Up**: Run `make clean` to uninstall the chart and delete the namespace.

Replace `<docker-repository-url>` and `<image-tag>` with the correct values for your Docker image.

