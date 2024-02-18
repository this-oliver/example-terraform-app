# Example Terraform App

> For a crash

This repository contains an example of how to deploy a basic web server using **Infrastructure as Code** + **Terraform**. The deployment consists of two services:

- **web server**: a simple express app that returns a simple html page.
- **nginx server**: a reverse proxy that routes traffic to the web server.

## Getting Started

Pre-requisites:

- install [Docker](https://docs.docker.com/get-docker/) on your local machine.
- install [Terraform](https://developer.hashicorp.com/terraform/install) on your local machine.

Build a Docker image for the web server:

```bash
# build locally
docker build -t example-terraform-app .

# push to Docker Hub (replace `thisoliver` with your Docker Hub username)
docker tag example-terraform-app thisoliver/example-terraform-app
docker push thisoliver/example-terraform-app
```

## Deploying the app

Check into Terraform in the deployment directory:

### Check into the terraform directory

```bash
cd deploy/terraform
```

### Initialize the terraform project

```bash
terraform init
```

notes:

- initialize the Terraform project with `terraform init` creates a `.terraform` directory that contains the plugins and modules that Terraform needs to manage your infrastructure. The command also creates a `terraform.lock.hcl` file that contains the versions of the plugins and modules that Terraform will use (similar to a `package-lock.json` file in Node.js).

### Plan changes to your infrastructure

```bash
terraform plan --var nginx_config=$(pwd)/nginx/default.conf --out=tfplan
```

notes:

- the `--var` flag in the `terraform plan` command allows you to pass variables to Terraform. In this case, we are passing the `nginx_config` variable, which is the path to the Nginx configuration file. This file can be found in the `nginx` directory in the terraform directory. **If you are using Windows, you will need to replace `$(pwd)` with the absolute path to the `nginx` directory.**
- the `--out` flag in the `terraform plan` command allows you to save the plan to a file (i.e. `--out=tfplan`). This is useful if you use dynamic variables in your Terraform configuration, as it allows you to save the plan and apply it later. Alternatively, you can run `terraform apply` without the `--out` flag to apply the plan immediately but this does not save any variables that you used in the plan (e.g. `nginx_config`) which means that you might fall back to the default values of the variables which might not be what you want.

### Apply the changes to your infrastructure

> Visit [localhost:8080](http://localhost:8080) to see the web server in action.

```bash
terraform apply
```

notes:

- if you run into issue with the **nginx** container, then it is most likely because of one of the following:
  - the port `8080` is already in use by another process on your local machine.
  - the `nginx` container is already running.
  - the `nginx` [config](./deploy//terraform//nginx/default.conf) is looking for a *app* container on its Docker network that doesn't exist because it was renamed in the [main.tf](./deploy//terraform//main.tf) file (see line 26)

## Cleaning up

To destroy the infrastructure, run:

```bash
terraform destroy
```

notes:

- if you have created your application's Docker image locally (i.e. `example-app:latest`), then the `terraform destroy` command will also remove the Docker image from your local machine. If you want to keep the Docker image, then you will need to tag it as `example-app:origin` at build time and then tag it as `example-app:latest` when you want to use it with Terraform. This way, Terraform will not remove the `example-app:origin` image when you run `terraform destroy`. Alternatively, you can push the `example-app:latest` image to a Docker registry (e.g. Docker Hub) and then pull it when you want to use it with Terraform.

## Documentation

## Infrastructure as Code (IaC)

> **IaC doesn't eliminate the need for this knowledge, but it does make it easier to manage your infrastructure once you have it set up**. Although IaC simplifies the process of setting up and managing infrastructure, it still requires a basic understanding of the infrastructure you are trying to create and the provider you are using. For example, if you want to create a virtual machine on GCP, you still need to have a vague idea of what a virtual machine is and which GCP service you need to use.

Infrastructure as Code (IaC) is a concept that allows you to define and manage your IT infrastructure using code. This means that you skip the manual process of setting up your servers, the network that connects them, and the different services that run on the servers. Instead, you define your infrastructure in a file, and then run a tool that interprets that file and creates the infrastructure for you.

**Key benefits**:

- **Agnostic to the underlying infrastructure**: You can define your infrastructure in a file, and then run the same file on different infrastructure providers. This means that you can easily switch from one infrastructure provider to another without having to rewrite your infrastructure. **You still need to have a vague idea of the infrastructure you are trying to create and the provider you are using but the code is *practically* the same.**
- **Maintainability**: Setting up IT infrastructure usually involves a number of infrastructure providers, dashboards, and different computational resources. In contrast, IaC allows you to define your infrastructure in a single file. This makes it easier to understand and maintain your infrastructure.
- **Reproducibility**: Because your infrastructure is defined in a file, you can easily recreate it. You don't have to click a bunch of buttons in a GCP dashboard (or command line) to set up your infrastructure. Instead, you can run a single command that will create your infrastructure for you.

## Terraform

[Terraform](https://www.terraform.io/) (**TF**) is a IaC tool for building, changing, and versioning infrastructure safely and efficiently. TF supports a wide range of infrastructure providers, including Docker, Kubernetes AWS, Azure, GCP, and many others. It allows you to define your infrastructure in a file using a simple, human-readable language, and then run a command that will create your infrastructure for you.

TF can be broken down into three steps:

1. **Define your infrastructue**: configure a `main.tf` file that defines your infrastructure.
2. **Plan**: run `terraform plan` to see what changes TF will make to your infrastructure.
3. **Apply**: run `terraform apply` to create your infrastructure.
