pipeline {
    agent any

    parameters {
        string(name: 'branch', defaultValue: 'main', description: 'GitHub branch')
        choice(name: 'environment', choices: ['staging', 'production'], description: 'Deployment env')
    }

    environment {
        AWS_ACCOUNT_ID = '226817436986'
        AWS_REGION     = 'us-east-1'
        REPO_NAME      = 'cloudbox-app'
        IMAGE_TAG      = "${params.branch}-${BUILD_NUMBER}"
    }

    stages {
        stage('Fetch Code') {
            steps {
                checkout scm
            }
        }

        stage('Registry Login') {
            steps {
                // This logs Jenkins into your AWS registry directly on the Linux runner
                sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
            }
        }

        stage('Build Image') {
            steps {
                sh "docker build -t ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}://{REPO_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push Image') {
            steps {
                sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}://{REPO_NAME}:${IMAGE_TAG}"
            }
        }

        stage('Deploy App') {
            steps {
                sh "IMAGE_TAG=${IMAGE_TAG} AWS_ACCOUNT_ID=${AWS_ACCOUNT_ID} AWS_REGION=${AWS_REGION} docker-compose down"
                sh "IMAGE_TAG=${IMAGE_TAG} AWS_ACCOUNT_ID=${AWS_ACCOUNT_ID} AWS_REGION=${AWS_REGION} docker-compose up -d"
            }
        }
    }
}
