pipeline {
    agent 
    {
        label 'built-in'
    }

    environment {
        DOCKERHUB_USER = credentials('dockerhub-username')   // Jenkins Credential ID
        DOCKERHUB_PASS = credentials('dockerhub-password')   // Jenkins Credential ID
        AWS_ACCESS_KEY_ID = credentials('aws-access-key')   // Jenkins Credential ID
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        IMAGE_NAME = "ashwkenny/trend-app" // Change this
        IMAGE_TAG  = "latest"
    }

    stages {

       stage('Terraform Infra') {
            steps {
                script {
                    sh """
                    export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                    export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                    export AWS_REGION=us-east-1 
                    cd infra
                    terraform init
                    terraform plan 
                    terraform apply --auto-approve
                    """
                }
            }
       }
        
        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                    """
                }
            }
        }

        stage('Docker Login') {
            steps {
                script {
                    sh """
                    echo "${DOCKERHUB_PASS}" | docker login -u "${DOCKERHUB_USER}" --password-stdin
                    """
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    sh """
                    docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    """
                }
            }
        }

        stage('Configure kubectl for EKS') {
            steps {
                sh '''
                    aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID}
                    aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}
                    aws configure set region 'us-east-1'

                    aws eks update-kubeconfig --region $AWS_REGION --name $EKS_CLUSTER
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                '''
            }
        }
    }

    post {
        always {
            sh 'docker logout'
            echo "Pipeline completed."
        }
    }
}
