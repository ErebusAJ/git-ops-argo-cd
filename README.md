# GitOps Terraform - Jenkins - K8s - Argo CD

This is a simple repository to setup and implement argocd with jenkins based CI pipeline and CD with ArgoCD in a mono-repo fashion.


## Project Structure

```
├── backend
│   ├── Dockerfile
│   └── index.html
├── Jenkinsfile
├── kubernetes
│   ├── argo-cd.yaml
│   ├── deployment.yaml
│   └── service.yaml
├── README.md
└── terraform
    ├── main.tf
    ├── scripts
    │   └── bootstrap.sh
    ├── ssh-keys
    │   ├── jenkins_ec2
    │   └── jenkins_ec2.pub
    ├── terraform.tfstate
    ├── terraform.tfstate.backup
    ├── terraform.tfvars
    └── variables.tf
```

## Pre Requisites

- A running kubernetes cluster I have used [Minikube](https://minikube.sigs.k8s.io/docs/)

- [ArgoCD](https://argo-cd.readthedocs.io/en/stable/) installed and working inside the k8s cluster

- [Terraform](https://developer.hashicorp.com/terraform) installed and [AWS CLI](https://aws.amazon.com/cli/) configured


## Backend

It contains the [Dockerfile](backend/Dockerfile) to build images and [index.html](backend/index.html) custom page that is served via nginx through k8s cluster.

---

## Terraform

Consists of the IAC provisioning code for `AWS` it spawns up a `ec2 t2.micro` instance ingesting a custom user [bootstrap.sh](terraform/scripts/bootstrap.sh) script which pre installs `jenkins` and `docker buildx` on the server.

## Kubernetes

This is where all the magic code happens. It has [deployment.yaml](kubernetes/deployment.yaml) for deploying the docker image pushed on docker hub registry [aaryaj/argo-cd](https://hub.docker.com/r/aaryaj/argo-cd).

The [argo-cd.yaml](kubernetes/argo-cd.yaml) contains argocd application manifest for specifying repository to point to for polling.

## Getting Started

- Clone Project

- Create RSA ssh key in `./terraform/ssh-keys`

    ```
    ssh-keygen -t rsa -b 4096 -f jenkins_ec2
    ```

- Terraform 
    ```
    terraform init
    terraform validate
    terraform plan
    terraform apply -auto-approve
    ```

- Apply k8s deployment

    ```
    kubectl apply -f kubernetes/
    ```

- Login to argoCD
    
- Setup Jenkins pipeline and trigger builds

- You have your own JenkinsCI-argoCD setup

## Showings

`Jenkins GitSCM Trigger Build`

![alt text](assets/Screenshot%202026-02-19%20at%2010.14.24 PM.png)

