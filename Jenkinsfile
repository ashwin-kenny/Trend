pipeline {
    agent 
    {
        label 'built-in'
    }

    environment {
        DOCKERHUB_USER = credentials('dockerhub-username')   // Jenkins Credential ID
        DOCKERHUB_PASS = credentials('dockerhub-password')   // Jenkins Credential ID
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
    }

    post {
        always {
            sh 'docker logout'
            echo "Pipeline completed."
        }
    }
}
