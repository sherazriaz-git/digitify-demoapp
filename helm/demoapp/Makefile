# Makefile to deploy DemoApp on AWS EKS

KUBECONFIG ?= ~/.kube/config
CLUSTER_NAME ?= digitify-demo-cluster
AWS_REGION ?= us-east-1

# Helm variables
HELM_RELEASE_NAME = demoapp-release
HELM_NAMESPACE = default
HELM_CHART_PATH = ../demoapp
HELM_VALUES_FILE = ${HELM_VALUES_FILE}

# Install/Upgrade the Helm chart
deploy:
	@echo "Deploying DemoApp on EKS..."
	@aws eks --region $(AWS_REGION) update-kubeconfig --name $(CLUSTER_NAME)
	@helm upgrade --install $(HELM_RELEASE_NAME) $(HELM_CHART_PATH) --namespace $(HELM_NAMESPACE) -f $(HELM_VALUES_FILE)

# Uninstall the Helm release
uninstall:
	@echo "Uninstalling DemoApp..."
	@helm uninstall $(HELM_RELEASE_NAME) --namespace $(HELM_NAMESPACE)

# Run the helm chart linting to check for any errors
lint:
	@echo "Linting Helm Chart..."
	@helm lint $(HELM_CHART_PATH)

# Check Helm chart dependencies
dependencies:
	@echo "Updating dependencies..."
	@helm dependency update $(HELM_CHART_PATH)
