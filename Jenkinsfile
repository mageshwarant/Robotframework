pipeline {
    agent any

    options {
        timestamps()
    }

    environment {
        // Jenkins runs as a Windows service, so Chrome must not require a desktop session.
        YAHOO_HEADLESS = 'true'
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
                    pip install robotframework robotframework-seleniumlibrary robotframework-requests
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
                    robot --outputdir results/FirstProgram FirstProgram.robot || exit /b 1
                    robot --outputdir results/apitest apitest.robot
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
