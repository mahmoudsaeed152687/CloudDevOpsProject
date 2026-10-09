# CloudDevOpsProject
<img width="1376" height="768" alt="Cloud_DevOps_Project" src="https://github.com/user-attachments/assets/403f6519-a7bb-4e83-b7a3-966515b89cbf" />

## End-to-End DevOps CI/CD Project

A production-style DevOps project implementing an end-to-end cloud-native deployment workflow on AWS.

The project demonstrates how a multi-service application can be containerized, provisioned using Terraform, configured using Ansible, deployed to Amazon EKS using Kubernetes, continuously integrated using Jenkins, and continuously deployed using ArgoCD following GitOps principles.

### Application Stack

* Frontend: Node.js / Express
* Auth Service: Python / Flask
* Roadmap Service: Java / Spring Boot
* Database: MySQL

### Main DevOps Workflow

```text
GitHub
   ↓
Jenkins CI
   ↓
Docker Build
   ↓
Trivy Scan
   ↓
Amazon ECR
   ↓
Kubernetes Manifest Update
   ↓
GitHub
   ↓
ArgoCD
   ↓
Amazon EKS
   ↓
AWS ALB
   ↓
Application
```

---

# Problems Faced & Solutions

## 1. Terraform State Drift

**Problem**

Terraform state did not match the actual AWS infrastructure after resources had been manually recreated or changed.

**Root Cause**

The existing EKS cluster and NAT Gateway were different from the resources tracked in Terraform state.

**Diagnostic Approach**

* Compared Terraform state with the actual AWS resources.
* Identified the correct existing resources.
* Removed stale resources from Terraform state.
* Imported the existing resources into Terraform.

**Solution**

```bash
terraform import module.eks.aws_eks_cluster.main ivolve-eks

terraform state rm module.network.aws_nat_gateway.main

terraform import module.network.aws_nat_gateway.main nat-0049eff49655fef19
```

Terraform was then able to reconcile the infrastructure without unnecessarily destroying working resources.

---

## 2. Jenkins Pipeline Failed to Push Kubernetes Manifest

**Problem**

The Jenkins pipeline successfully built and pushed the Docker image and updated the Kubernetes manifest, but the final Git push failed.

**Root Cause**

Jenkins checks out the repository in a detached HEAD state.

The original command was:

```bash
git push origin main
```

**Solution**

The Jenkins Shared Library was changed to explicitly push the current commit to the remote branch:

```bash
git push origin HEAD:main
```

After this change, the manifest push succeeded and the updated image tag was committed back to GitHub.

---

## 3. Kubernetes Ingress Had No AWS Load Balancer

**Problem**

The Kubernetes Ingress existed, but the `ADDRESS` field remained empty.

**Diagnostic Approach**

```bash
kubectl get ingress -n ivolve
```

The Ingress existed but no AWS Load Balancer was created.

The EKS cluster was then checked for the AWS Load Balancer Controller:

```bash
kubectl get pods -n kube-system
```

The controller was not installed.

**Root Cause**

The EKS cluster had the required Pod Identity association, but the AWS Load Balancer Controller itself was missing.

**Solution**

The AWS Load Balancer Controller was installed using Helm and configured to use the existing EKS Pod Identity association.

After installation, the controller pods became `Running`, and the Ingress received an AWS Application Load Balancer address.

The application was then successfully accessible through the internet-facing ALB.

---

# AI-Assisted Development

AI was used as an engineering assistant throughout the project, mainly for troubleshooting, investigation, documentation, and validating implementation decisions.

The AI was not used as a replacement for implementation. Infrastructure, CI/CD pipelines, Kubernetes resources, and application deployment were executed, tested, and verified in the actual AWS environment.

### Troubleshooting & Root Cause Analysis

AI was used to analyze real errors and logs, identify possible root causes, and determine useful diagnostic commands.

Examples included:

* Terraform state drift between Terraform and AWS resources.
* Jenkins Git push failures caused by detached HEAD.
* Kubernetes Ingress with an empty AWS Load Balancer address.
* EKS and Kubernetes deployment issues.
* Docker and container build problems.

The workflow was:

```text
Real Error / Log
      ↓
AI Analysis
      ↓
Possible Root Causes
      ↓
Diagnostic Commands
      ↓
Real Environment Testing
      ↓
Root Cause Confirmation
      ↓
Solution
```

### Infrastructure Design

AI was used to discuss and validate infrastructure decisions before implementation, including:

* AWS VPC architecture
* Public and private subnet design
* NAT Gateway routing
* EKS networking
* IAM and Pod Identity
* Terraform module structure
* Remote Terraform state

The final configuration was implemented and verified using Terraform and AWS.

### CI/CD Development

AI assisted with designing and troubleshooting Jenkins pipelines and Shared Library functions.

Examples included:

* Docker image build workflow
* Trivy image scanning
* Amazon ECR image pushing
* Kubernetes manifest updates
* Git automation
* Jenkins detached HEAD troubleshooting
* Jenkins Shared Library design

### Kubernetes Troubleshooting

AI was also used during Kubernetes deployment and troubleshooting.

For example, when the Ingress had no external address, the investigation followed this process:

```text
Ingress exists
      ↓
No ALB address
      ↓
Check Ingress events
      ↓
Check AWS Load Balancer Controller
      ↓
Controller missing
      ↓
Verify Pod Identity
      ↓
Install Controller with Helm
      ↓
Controller Running
      ↓
ALB Created
```

### Documentation & Knowledge Development

AI was used to:

* Explain unfamiliar technologies and commands.
* Analyze troubleshooting sessions.
* Convert troubleshooting into documented engineering decisions.
* Improve project documentation.
* Structure the final README.
* Explain why specific tools and architectural decisions were used.

### AI Usage Philosophy

The project followed a Human-in-the-Loop approach:

> AI suggested approaches and helped analyze problems; implementation, testing, verification, and final engineering decisions were performed by the developer.

---

# Architecture

```text
                         Internet
                            │
                            ▼
                    ┌───────────────┐
                    │    AWS ALB    │
                    │    Ingress    │
                    └───────┬───────┘
                            │
                            ▼
                    ┌───────────────┐
                    │   Frontend    │
                    │   Node.js     │
                    │    :3000      │
                    └───────┬───────┘
                            │
                 ┌──────────┴──────────┐
                 │                     │
                 ▼                     ▼
        ┌─────────────────┐   ┌─────────────────┐
        │  Auth Service   │   │ Roadmap Service │
        │ Python / Flask  │   │ Java / Spring   │
        │      :5000      │   │      :8080      │
        └────────┬────────┘   └─────────────────┘
                 │
                 ▼
        ┌─────────────────┐
        │      MySQL      │
        │     :3306       │
        │   StatefulSet   │
        └────────┬────────┘
                 │
                 ▼
              EBS Volume
```

---

# AWS Infrastructure

The infrastructure is provisioned using Terraform.

### Network

* VPC: `10.0.0.0/16`
* 2 Availability Zones
* 2 Public Subnets
* 2 Private Subnets
* Internet Gateway
* NAT Gateway
* Public and Private Route Tables
* Network ACL

### AWS Services

* Amazon EC2
* Amazon EKS
* Amazon ECR
* Amazon EBS
* AWS Application Load Balancer
* IAM
* EKS Pod Identity

### Network Design

```text
                         AWS VPC
                      10.0.0.0/16
                           │
              ┌────────────┴────────────┐
              │                         │
        Public Subnets            Private Subnets
              │                         │
        ┌─────┴─────┐             ┌─────┴─────┐
        │           │             │           │
     Jenkins    Ansible        EKS Node    EKS Node
        │                         │           │
        └────────── NAT Gateway ──┴───────────┘
```

---

# Docker

The application is containerized using separate Dockerfiles for each service.

### Frontend

```dockerfile
FROM node:22-alpine

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
```

### Auth Service

```dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
```

### Roadmap Service

The Roadmap Service uses a multi-stage Docker build:

```text
Maven Build Image
       │
       ▼
Spring Boot JAR
       │
       ▼
JRE Runtime Image
```

This separates the build environment from the runtime environment and reduces the final runtime image footprint.

---

# Terraform

Terraform is organized into reusable modules.

```text
terraform/
├── main.tf
├── providers.tf
├── backend.tf
└── modules/
    ├── network/
    ├── server/
    ├── ansible/
    ├── eks/
    └── ecr/
```

### Terraform Modules

| Module  | Responsibility                       |
| ------- | ------------------------------------ |
| Network | VPC, subnets, IGW, NAT, routes, NACL |
| Server  | Jenkins EC2 and supporting resources |
| Ansible | Ansible Controller EC2               |
| EKS     | EKS cluster and worker nodes         |
| ECR     | Container registries                 |

### Remote State

Terraform state is stored remotely in Amazon S3.

```text
Terraform
    │
    ▼
Amazon S3
    │
    └── terraform.tfstate
```

A separate bootstrap configuration is used to provision the Terraform state bucket.

---

# Ansible

Ansible is used to automate configuration of the Jenkins environment.

The automation includes:

* Java
* Jenkins
* Docker
* Trivy

The configuration uses reusable roles and playbooks instead of manually configuring each server.

---

# Kubernetes

The application is deployed to the:

```text
ivolve
```

namespace.

### Kubernetes Resources

**Frontend**

* Deployment
* Service
* ConfigMap
* Secret
* Ingress

**Auth Service**

* Deployment
* Service
* ConfigMap
* Secret

**Roadmap Service**

* Deployment
* Service

**MySQL**

* StatefulSet
* Headless Service
* PersistentVolumeClaim
* StorageClass

### EKS Nodes

Two worker nodes are deployed across different Availability Zones and private subnets.

---

# Persistent Storage

MySQL uses Amazon EBS-backed persistent storage.

```text
MySQL StatefulSet
       │
       ▼
PersistentVolumeClaim
       │
       ▼
EBS Volume
```

Verified deployment:

```text
PVC: mysql-pvc
Status: Bound
Capacity: 5Gi
Access Mode: RWO
StorageClass: ebs-sc
```

---

# Jenkins CI

Jenkins provides Continuous Integration for all three services:

```text
frontend
auth-service
roadmap-service
```

Each pipeline follows the same workflow:

```text
Build Image
     ↓
Trivy Scan
     ↓
Push Image
     ↓
Delete Local Image
     ↓
Update Manifest
     ↓
Push Manifest
```

### Amazon ECR

Three repositories are used:

```text
ivolve-frontend
ivolve-auth-service
ivolve-roadmap-service
```

Image tags are generated from Jenkins build numbers.

Example:

```text
ivolve-frontend:21
ivolve-auth-service:1
ivolve-roadmap-service:1
```

---

# Jenkins Shared Library

Common pipeline functionality is implemented through a Jenkins Shared Library.

Reusable functions include:

```text
dockerBuild()
trivyScan()
dockerPush()
dockerCleanup()
updateManifest()
pushManifests()
```

This avoids duplicating the same CI logic across the three pipelines.

---

# Trivy Security Scanning

Trivy is integrated into Jenkins to scan container images for vulnerabilities.

The scan checks for:

```text
HIGH
CRITICAL
```

severity vulnerabilities.

During development, the scan was configured as non-blocking so that vulnerabilities remained visible in Jenkins while the CI/CD workflow could continue.

---

# ArgoCD / GitOps

ArgoCD provides Continuous Deployment using GitOps.

The Kubernetes manifests are stored in GitHub:

```text
k8s/
├── namespace.yaml
├── frontend/
├── auth-service/
├── roadmap-service/
└── mysql/
```

ArgoCD monitors the repository and synchronizes the desired state with the EKS cluster.

```text
GitHub
   │
   ▼
 ArgoCD
   │
   ▼
 Amazon EKS
   │
   ▼
 Kubernetes Resources
```

The ArgoCD Application tracks:

```text
Repository: CloudDevOpsProject
Branch: main
Path: k8s
Namespace: ivolve
```

Recursive directory processing is enabled to load manifests inside the service directories.

---

# Security

Security practices implemented in the project include:

* Private EKS worker nodes
* IAM roles
* EKS Pod Identity
* Trivy container scanning
* Kubernetes Secrets
* Private ECR repositories
* Password hashing using bcrypt
* GitHub SSH authentication
* Public/private subnet separation

---

# Project Structure

```text
CloudDevOpsProject/
│
├── frontend/
├── auth-service/
├── roadmap-service/
│
├── k8s/
│   ├── namespace.yaml
│   ├── frontend/
│   ├── auth-service/
│   ├── roadmap-service/
│   └── mysql/
│
├── terraform/
│   ├── main.tf
│   ├── providers.tf
│   ├── backend.tf
│   └── modules/
│       ├── network/
│       ├── server/
│       ├── ansible/
│       ├── eks/
│       └── ecr/
│
├── bootstrap/
│   └── main.tf
│
├── ansible/
│
├── jenkins/
│   ├── pipelines/
│   │   ├── frontend.Jenkinsfile
│   │   ├── auth.Jenkinsfile
│   │   └── roadmap.Jenkinsfile
│   │
│   └── shared-library/
│       └── vars/
│
└── argocd/
    └── application.yaml
```

---

# Technologies Used

| Category                 | Technologies       |
| ------------------------ | ------------------ |
| Cloud                    | AWS                |
| Infrastructure as Code   | Terraform          |
| Configuration Management | Ansible            |
| Containerization         | Docker             |
| Container Registry       | Amazon ECR         |
| Orchestration            | Kubernetes         |
| Kubernetes Platform      | Amazon EKS         |
| Storage                  | Amazon EBS         |
| CI                       | Jenkins            |
| Security Scanning        | Trivy              |
| CD / GitOps              | ArgoCD             |
| Source Control           | Git / GitHub       |
| Frontend                 | Node.js / Express  |
| Auth Service             | Python / Flask     |
| Roadmap Service          | Java / Spring Boot |
| Database                 | MySQL              |

---

# Key DevOps Practices Demonstrated

* Infrastructure as Code
* Modular Terraform
* Remote Terraform State
* AWS Networking
* Multi-AZ Architecture
* Public / Private Subnet Design
* NAT Gateway
* IAM
* Amazon EKS
* Kubernetes
* Stateful Applications
* Persistent Storage
* Docker
* Container Security Scanning
* Jenkins CI
* Jenkins Shared Libraries
* Amazon ECR
* GitOps
* ArgoCD
* AWS Load Balancer Controller
* Infrastructure Troubleshooting
* CI/CD Troubleshooting

---

# Final Result

The project successfully implements an end-to-end DevOps workflow:

```text
Developer
    │
    ▼
 GitHub
    │
    ▼
 Jenkins
    │
    ├── Build
    ├── Scan
    ├── Push → ECR
    └── Update Manifest
             │
             ▼
          GitHub
             │
             ▼
          ArgoCD
             │
             ▼
           EKS
             │
             ▼
          AWS ALB
             │
             ▼
       Running Application
```

The application was successfully deployed to Amazon EKS and accessed externally through an AWS Application Load Balancer.

---

# Author

**Mahmoud Saeed**

DevOps / Cloud Engineer

GitHub: `mahmoudsaeed152687`
