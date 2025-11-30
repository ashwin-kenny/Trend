# React JS Nginx Image Deployed in EKS CLuster / CICD JENKINS / Terraform EC2, VPC, IAM

* This project contains the executable code of React JS deployed in EKS cluster.
* CICD using Jenkins. Terraform used to create EC2, VPC, IAM roles which hosts jenkins and docker.

## Tools to be installed (amazon Linux)

### Git
* sudo yum update -y
* sudo yum install git -y
* git --version

### Terraform
* sudo yum install -y yum-utils
* sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
* sudo yum install terraform -y
* terraform -version

### Docker

* sudo amazon-linux-extras install docker -y
* sudo systemctl start docker
* sudo systemctl enable docker
* sudo usermod -aG docker ec2-user
* docker info
* docker --version

### Jenkins

* sudo amazon-linux-extras install java-openjdk11 -y
* sudo wget -O /etc/yum.repos.d/jenkins.repo \
* https://pkg.jenkins.io/redhat-stable/jenkins.repo
* sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
* sudo yum install jenkins -y
* sudo systemctl start jenkins
* sudo systemctl enable jenkins
* sudo usermod -aG docker jenkins
* sudo systemctl restart jenkins

To retreive password:

* sudo cat /var/lib/jenkins/secrets/initialAdminPassword

Browse at: http://EC2-Public-IP:8080

### Create DockerHub Account

* Navigate to hub.docker.com and sign up.

##  Pipeline Overview

### Create Infra

* Create infra/main.tf file with required resource blocks for aws.(AWS EC2, IAM Role, VPC)

Run Terraform Commands:

* terraform init - Downloads providers, configures backend
* terraform plan - Shows what will change
* terraform apply --auto-approve - Makes real changes in AWS

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/1f6c7aa6-7c79-4bda-b406-18941ec89581" />


### Build and Push Docker Image

* Create Dockerfile
* Build the Docker Image, login, push using Below Commands: Replace ${IMAGE_NAME} and ${IMAGE_TAG} with your desired values.

docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
echo "${DOCKERHUB_PASS}" | docker login -u "${DOCKERHUB_USER}" --password-stdin
docker push ${IMAGE_NAME}:${IMAGE_TAG}

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/d362ca38-fba3-45c2-801f-c8740b25b05c" />

### Deploy To Kubernetes EKS CLuster

* Authenticate to EKS using below commands

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/1b31b42a-0557-4e4f-a72d-7fd81f9b87d5" />

* Deploy the deployment.yaml and service.yaml to EKS using kubectl below commands

  <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/212cd6fc-8be5-47bb-bbb6-28d16dec3b2e" />

* deployment.yaml - Uses the image ashwkenny/trend-app from dockerhub and creates a kuberneters deployment by creating two pods as defined in replica sets.
* service.yaml - Exposes the pods deployed in EKS via loadbalancer service in port 3000.

## Results

### Jenkins Pipeline Result:

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/95334108-cabc-4dab-9403-6cd298eb52ec" />

### Terraform Results:

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/1a7a1d75-ac4d-47af-a493-b604df706c8c" />

### EKS Resources:

* Pods

  <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/51c1a8d2-c684-4d27-a2ec-e646bf9a4dfd" />

* Services

  <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/296f168a-6c29-4131-b2c9-4e43b5022e4a" />








