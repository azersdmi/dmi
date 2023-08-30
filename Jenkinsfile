pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/azersdmi/dmi.git']])
            }
        }

        stage('Terraform init') {
            steps {
                sh 'sudo terraform init -backend-config="access_key=AKIARNGVWZTHKC7IIJEN" -backend-config="secret_key=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"'
            }
        }

        
        stage('Terraform apply') {
            steps {
                sh 'terraform apply --auto-approve'

            }

        }

    }

}
