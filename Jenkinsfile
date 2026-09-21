pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Check Salesforce CLI') {
            steps {
                bat 'sf --version'
            }
        }

        stage('Deploy to Salesforce') {
            steps {
                bat '''
                    sf project deploy start ^
                    --source-dir force-app ^
                    --target-org TargetOrg
                '''
            }
        }
    }
}
