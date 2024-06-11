Sure! Here’s a comprehensive `README.md` file for your project:

---

# AWS ECS Deployment Automation with Terraform and GitHub Actions

## Overview

This project automates the deployment and management of an application on Amazon Web Services (AWS) using Terraform and GitHub Actions. It leverages Infrastructure as Code (IaC) principles to ensure consistent and reliable provisioning of resources.

## Table of Contents

1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Project Structure](#project-structure)
4. [Getting Started](#getting-started)
    - [Clone the Repository](#clone-the-repository)
    - [Setup AWS Credentials](#setup-aws-credentials)
    - [Configure GitHub Secrets](#configure-github-secrets)
    - [Run the Workflow](#run-the-workflow)
5. [Infrastructure Configuration](#infrastructure-configuration)
6. [GitHub Actions Workflow](#github-actions-workflow)
7. [Troubleshooting](#troubleshooting)
8. [Contributing](#contributing)
9. [License](#license)

## Introduction

This project demonstrates how to use Terraform to manage AWS infrastructure and GitHub Actions to automate the CI/CD pipeline. It includes:

- Terraform scripts to provision AWS resources.
- GitHub Actions workflow to build, test, and deploy the application.

## Prerequisites

Before you begin, ensure you have the following installed:

- [Terraform](https://www.terraform.io/downloads)
- [Docker](https://docs.docker.com/get-docker/)
- [AWS CLI](https://aws.amazon.com/cli/)
- [Git](https://git-scm.com/)

## Project Structure

```plaintext
.
├── .github
│   └── workflows
│       └── actions.yml      
├── main.tf              
├── Dockerfile           
└── index.js
└── .gitignore     
└── README.md                
```

## Getting Started

### Clone the Repository

```bash
git clone https://github.com/maheshwaranandh/_CI-CD-Automation-with-Terraform-and-GitHub-Actions
cd my-repo
```

### Setup AWS Credentials

Configure your AWS credentials using the AWS CLI:

```bash
aws configure
```

Provide your AWS Access Key ID, Secret Access Key, region, and output format when prompted.

### Configure GitHub Secrets

Add the following secrets to your GitHub repository:

- `DOCKER_HUB_USERNAME`: Your Docker Hub username.
- `DOCKER_HUB_PASSWORD`: Your Docker Hub password.
- `AWS_ACCESS_KEY_ID`: Your AWS Access Key ID.
- `AWS_SECRET_ACCESS_KEY`: Your AWS Secret Access Key.
- `AWS_REGION`: Your AWS region.

### Run the Workflow

Push your changes to the `main` branch to trigger the GitHub Actions workflow:

```bash
git add .
git commit -m "Initial commit"
git push origin main
```

The workflow will automatically build and deploy the application to AWS ECS.

## Infrastructure Configuration

The Terraform configuration (`main.tf`) provisions the following AWS resources:

- VPC (Virtual Private Cloud)
- Subnets
- ECS Cluster
- ECS Task Definition
- ECS Service
- Security Groups
- Load Balancer

## GitHub Actions Workflow

The GitHub Actions workflow (`.github/workflows/actions.yml`) includes the following steps:

1. **Checkout Code**: Check out the repository code.
2. **Login to Docker Hub**: Authenticate to Docker Hub using secrets.
3. **Build and Push Docker Image**: Build the Docker image and push it to Docker Hub.
4. **Setup Terraform**: Install and configure Terraform.
5. **Initialize Terraform**: Initialize Terraform.
6. **Apply Terraform Configuration**: Apply the Terraform configuration to provision resources.
7. **Wait**: Wait for the resources to be provisioned.
8. **Deploy to ECS**: Update the ECS service to use the new task definition.

## Troubleshooting

### Terraform Destroy Hangs

If `terraform destroy` hangs during a GitHub Actions run due to a missing `-auto-approve` flag, manually destroy the resources by setting up the environment locally:

```bash
terraform init
terraform destroy -auto-approve
```

### AWS Authentication Issues

Ensure your AWS credentials are correctly configured and have the necessary permissions to manage ECS and related resources.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

