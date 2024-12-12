# Java Application Deployment to Amazon EKS

## Overview
This repository contains a Java application and Helm charts for deploying the application to Amazon Elastic Kubernetes Service (EKS). The deployment ensures scalability, resilience, and ease of management.

## Prerequisites

Before deploying, ensure the following:

1. **Tools Installed**:
   - [Helm](https://helm.sh/docs/intro/install/) v3+
   - [kubectl](https://kubernetes.io/docs/tasks/tools/)
   - [AWS CLI](https://aws.amazon.com/cli/) v2+
   - [Java](https://www.java.com/) (JDK 11 or later)
   - Docker

2. **Amazon EKS Cluster**:
   - A fully configured and running EKS cluster.
   - `kubectl` configured to interact with the cluster.

3. **IAM Roles**:
   - Ensure necessary IAM roles and permissions are attached to the cluster for Helm and Kubernetes resources.

4. **Docker Image**:
   - Build and push your Java application Docker image to a container registry (e.g., Amazon ECR, DockerHub).

## Repository Structure

```plaintext
.
├── Dockerfile
├── HELP.md
├── README.md
├── demoapp.yaml
├── helm
│   └── demoapp
│       ├── Chart.yaml
│       ├── Makefile
│       ├── templates
│       │   ├── deployment.yaml
│       │   ├── hpa.yaml
│       │   ├── ingress.yaml
│       │   └── service.yaml
│       └── values.yaml
├── hpa.yaml
├── mvnw
├── mvnw.cmd
├── pom.xml
└── src
    ├── main
    │   ├── java
    │   │   └── com
    │   │       └── digitify
    │   │           └── DemoApp
    │   │               └── DemoAppApplication.java
    │   └── resources
    │       ├── application.properties
    │       ├── static
    │       └── templates
    └── test
        └── java
            └── com
                └── digitify
                    └── DemoApp
                        └── DemoAppApplicationTests.java
```
### Local Setup
## Build and Push Docker Image

1. **Build the Image**:
   ```bash
   docker build -t <your-repo>/<image-name>:<tag> .
   ```

2. **Push to Container Registry**:
   ```bash
   docker push <your-repo>/<image-name>:<tag>
   ```

## Helm Deployment

### Steps to Deploy

1. **Add the Docker Image to `demoapp.yaml`**:
   Update the `image.repository` and `image.tag` fields in `demoapp.yaml`:
   ```yaml
   image:
     repository: <your-repo>/<image-name>
     tag: <tag>
   ```

2. **Install the Helm Chart**:
   ```bash
   helm upgrade   demoapp ./demoapp -f ../demoapp.yaml     
   ```

3. **Verify Deployment**:
   ```bash
   kubectl get all 
   ```

4. **Access the Application**:
   - If using a LoadBalancer, find the external IP:
     ```bash
     kubectl get svc 
     ```
   - Open the application in your browser using the IP or DNS name.

### Updating the Deployment

To apply updates:
```bash
helm upgrade   demoapp ./demoapp -f ../demoapp.yaml     
```

### Uninstalling the Deployment

To remove the application:
```bash
helm uninstall demoapp
```

### CI/CD Pipeline

## Features
- Upon each commit run the maven test
- Upon PR merged to master docker image got build and got scanned with secirity tool Trivy
- Upon PR merged to master deploy the latest helm chart on AWS EKS



## Directory Structure

```plaintext
.github
├── actions
│   ├── build
│   │   └── action.yml
│   └── deploy
│       └── action.yml
└── workflows
    └── build-push.yml
```

### Setup Environmetn Variables and secrets in Github repository
Secrets:
- AWS_IAM_ROLE

Environment variables:
- AWS_REGION
- ECR_REPO_NAME
- EKS_CLUSTER_NAME

The CI/CD pipeline is implemented using GitHub Actions and consists of the following workflows:
 ```
1. Upon each commit to any branch pipeline will trigger Maven tests only
2. Upon commit to main branch, pipeline will
  - build the docker image
  - Scan the docker image with Trivy
  - Push image to ECR
  - Udate the EKS with latest helm configurations
 ```





