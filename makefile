# Variables
CHART_NAME := java-web-app
CHART_VERSION := 1.0.0
CHART_DIR := ./helm-charts/$(CHART_NAME)
NAMESPACE := test-namespace
DOCKER_REPO := <docker-repository-url>
IMAGE_TAG := <image-tag>
EKS_CLUSTER_NAME := <eks-cluster-name>
AWS_REGION := <aws-region>
KUBECONFIG := ~/.kube/config

# Default target
.PHONY: all
all: deploy

# Update kubeconfig for EKS
.PHONY: update-kubeconfig
update-kubeconfig:
	@echo "Updating kubeconfig for EKS cluster..."
	aws eks update-kubeconfig --name $(EKS_CLUSTER_NAME) --region $(AWS_REGION)

# Lint the Helm chart
.PHONY: lint
lint:
	@echo "Linting Helm chart..."
	helm lint $(CHART_DIR)

# Package the Helm chart
.PHONY: package
package:
	@echo "Packaging Helm chart..."
	helm package $(CHART_DIR) --destination $(CHART_DIR)/packages

# Install or upgrade the Helm chart
.PHONY: deploy
deploy: lint package
	@echo "Deploying Helm chart to cluster..."
	helm upgrade --install $(CHART_NAME) $(CHART_DIR)/packages/$(CHART_NAME)-$(CHART_VERSION).tgz \
		--namespace $(NAMESPACE) \
		--create-namespace \
		--set image.repository=$(DOCKER_REPO) \
		--set image.tag=$(IMAGE_TAG)

# Check deployment status
.PHONY: status
status:
	@echo "Checking Helm release status..."
	helm status $(CHART_NAME) -n $(NAMESPACE)

# Delete the Helm release
.PHONY: clean
clean:
	@echo "Uninstalling Helm chart..."
	helm uninstall $(CHART_NAME) -n $(NAMESPACE)
	@echo "Cleaning up namespace..."
	kubectl delete namespace $(NAMESPACE) || true