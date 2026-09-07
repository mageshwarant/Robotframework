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

        stage('Setup Python Environment') {
            steps {
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install --upgrade pip
                    pip install robotframework
                    # If you have a requirements.txt with extra libraries (robotframework-seleniumlibrary etc.)
                    if [ -f requirements.txt ]; then
                        pip install -r requirements.txt
                    fi
                '''
            }
        }

        stage('Run Robot Framework Tests') {
            steps {
                sh '''
                    . venv/bin/activate
                    robot --outputdir results tests/
                '''
            }
        }
    }

    post {
        always {
            // Publish Robot Framework results if the Robot Framework Jenkins plugin is installed
            robot outputPath: 'results'

            // Archive raw results as a fallback / for download
            archiveArtifacts artifacts: 'results/**', allowEmptyArchive: true
        }
    }
}
