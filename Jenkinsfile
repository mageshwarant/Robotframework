pipeline {
    agent any

    options {
        timestamps()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Test Runner Image') {
            steps {
                bat '''
                    docker build --tag robotframework-tests:%BUILD_NUMBER% .
                '''
            }
        }

        stage('Run Robot Framework Tests') {
            steps {
                bat '''
                    if not exist results mkdir results
                    docker run --rm -e YAHOO_HEADLESS=true -v "%CD%\\results:/app/results" robotframework-tests:%BUILD_NUMBER%
                '''
            }
        }
    }

    post {
        always {
            // Archive reports regardless of whether the suite passes.
            archiveArtifacts artifacts: 'results/**', allowEmptyArchive: true
        }
    }
}
