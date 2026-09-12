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
                bat '''
                    python -m venv venv
                    call venv\\Scripts\\activate
                    pip install --upgrade pip
                    pip install robotframework robotframework-seleniumlibrary
                    if exist requirements.txt (
                        pip install -r requirements.txt
                    )
                '''
            }
        }

        stage('Run Robot Framework Tests') {
            steps {
                bat '''
                    call venv\\Scripts\\activate
                    robot --outputdir results FirstProgram.robot
                '''
            }
        }
    }

    post {
        always {
            // Archive results regardless of pass/fail.
            // If you install the "Robot Framework" Jenkins plugin later,
            // you can add: robot outputPath: 'results'
            archiveArtifacts artifacts: 'results/**', allowEmptyArchive: true
        }
    }
}
