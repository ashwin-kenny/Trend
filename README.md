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

* To retreive password:
* sudo cat /var/lib/jenkins/secrets/initialAdminPassword

* Browse at: http://<EC2-Public-IP>:8080

### Create DockerHub Account

* Navigate to hub.docker.com and sign up.

## CI Pipelinne

### Create Infra

* Create infra/main.tf file with required resource blocks for aws.(AWS EC2, IAM Role, VPC)
* Run Terraform Commands:

* terraform init - Downloads providers, configures backend
* terraform plan - Shows what will change
* terraform apply --auto-approve - Makes real changes in AWS



### Build Docker Image



### Push Docker Image

