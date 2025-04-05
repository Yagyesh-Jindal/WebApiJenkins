// For terraform
pipeline {
    agent any

    environment {
        ARM_CLIENT_ID       = credentials('AZURE_CLIENT_ID')
        ARM_CLIENT_SECRET   = credentials('AZURE_CLIENT_SECRET')
        ARM_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
        ARM_TENANT_ID       = credentials('AZURE_TENANT_ID')
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Yagyesh-Jindal/WebApiJenkins.git', branch: 'master'
            }
        }

        stage('Terraform Init') {
            steps {
                bat 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                bat '''
                    terraform plan ^
                      -var client_id=%ARM_CLIENT_ID% ^
                      -var client_secret=%ARM_CLIENT_SECRET% ^
                      -var tenant_id=%ARM_TENANT_ID% ^
                      -var subscription_id=%ARM_SUBSCRIPTION_ID%
                    '''
            }
        }

        stage('Terraform Apply') {
            steps {
                bat '''
                terraform apply -auto-approve ^
                  -var client_id=%ARM_CLIENT_ID% ^
                  -var client_secret=%ARM_CLIENT_SECRET% ^
                  -var tenant_id=%ARM_TENANT_ID% ^
                  -var subscription_id=%ARM_SUBSCRIPTION_ID%
                '''
            }
        }
         stage('Build .NET App') {
            steps {
                dir('WebApiJenkins') { // Adjust to your .NET project folder
                    bat 'dotnet publish -c Release -o publish'
                }
            }
        }

        stage('Deploy to Azure') {
            steps {
                bat '''
                powershell Compress-Archive -Path WebApiJenkins\\publish\\* -DestinationPath publish.zip -Force
                az webapp deployment source config-zip --resource-group jenkins-yagyesh-rg --name jenkins-yagyesh-app123 --src publish.zip
                '''
            }
        }   
    }
}
