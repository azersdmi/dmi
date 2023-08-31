pipeline {
    agent any

    stages {
        stage('Check') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/azersdmi/dmi.git']])
            }
        }

        stage('Init') {
            steps {
                sh 'sudo terraform init -backend-config="access_key=AKIARNGVWZTHKC7IIJEN" -backend-config="secret_key=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"'
            }
        }

        
        stage('Apply') {
            steps {
                sh 'terraform apply --auto-approve'

            }

        }

    }

}
