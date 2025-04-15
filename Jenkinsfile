pipeline {
    agent any

    environment {
        AZURE_CREDENTIALS_ID = 'jenkins-pipeline-sp'
        ACR_NAME = 'codecraftacr123'
        ACR_LOGIN_SERVER = 'codecraftacr123.azurecr.io'
        IMAGE_NAME = 'webapidocker1'
        RESOURCE_GROUP = 'codecraft-rg'
        CLUSTER_NAME = 'codecraft-aks'
        K8S_NAMESPACE = 'default'
        TF_WORKING_DIR = '.'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Yagyesh-Jindal/WebApiJenkins.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${ACR_LOGIN_SERVER}/${IMAGE_NAME}:latest", "--file ./Dockerfile .")
                }
            }
        }

        stage('Login to ACR') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
                    sh '''
                        az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID
                        az acr login --name $ACR_NAME
                    '''
                }
            }
        }

        stage('Push Image to ACR') {
            steps {
                script {
                    docker.withRegistry("https://${ACR_LOGIN_SERVER}", '') {
                        dockerImage.push('latest')
                    }
                }
            }
        }

        stage('Deploy to AKS') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
                    sh '''
                        az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID
                        az aks get-credentials --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME --overwrite-existing
                        kubectl apply -f ./k8s/
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment to AKS Successful!'
        }
        failure {
            echo 'Deployment Failed!'
        }
    }
}
