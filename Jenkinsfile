pipeline {
    agent any

    options {
        timestamps()
        timeout(time: 60, unit: 'MINUTES')
        buildDiscarder(logRotator(numToKeepStr: '20', artifactNumToKeepStr: '10'))
    }

    environment {
        // Headless Chrome for CI environments
        YAHOO_HEADLESS = 'true'
        // Python virtual environment path
        VENV_DIR = 'venv'
        // Maven installation on the Windows Jenkins agent.
        MAVEN_HOME = 'C:/Program Files/maven'
        // Maven options for CI
        MAVEN_OPTS = '-Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Validate Environment') {
            steps {
                script {
                    // Verify required tools are available
                    bat '''
                        echo "=== Environment Validation ==="
                        java -version
                        "%MAVEN_HOME%\\bin\\mvn.cmd" -version
                        python --version
                        python -m pip --version
                        chrome.exe --version 2>nul || echo "Chrome not in PATH (Selenium will auto-download)"
                    '''
                }
            }
        }

        stage('Setup Python Environment') {
            steps {
                bat '''
                    echo "=== Setting up Python Virtual Environment ==="
                    if not exist %VENV_DIR% (
                        python -m venv %VENV_DIR%
                    )
                    %VENV_DIR%\\Scripts\\python -m pip install --upgrade pip
                    %VENV_DIR%\\Scripts\\python -m pip install -r requirements.txt
                    %VENV_DIR%\\Scripts\\python -m pip list
                '''
            }
        }

        stage('Static Analysis') {
            steps {
                bat '''
                    echo "=== Running Robot Framework Lint ==="
                    %VENV_DIR%\\Scripts\\robotcode analyze code .
                '''
            }
        }

        stage('Run Tests in Parallel') {
            parallel {
                stage('Web Tests (Yahoo Finance)') {
                    steps {
                        script {
                            catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                                bat '''
                                    echo "=== Running Yahoo Finance Web Tests ==="
                                    call "%MAVEN_HOME%\\bin\\mvn.cmd" -B -Pyahoo verify
                                '''
                            }
                        }
                    }
                    post {
                        always {
                            junit testResults: 'results/FirstProgram/xunit.xml', allowEmptyResults: true
                        }
                    }
                }
                stage('API Tests') {
                    steps {
                        bat '''
                            echo "=== Running API Tests ==="
                            call "%MAVEN_HOME%\\bin\\mvn.cmd" -B -Papi verify
                        '''
                    }
                    post {
                        always {
                            junit testResults: 'results/apitest/xunit.xml', allowEmptyResults: true
                        }
                    }
                }
            }
        }

        stage('Aggregate Results') {
            steps {
                bat '''
                    echo "=== Aggregating Test Results ==="
                    %VENV_DIR%\\Scripts\\rebot --outputdir results/aggregated --xunit xunit.xml --name AggregatedResults results/FirstProgram/output.xml results/apitest/output.xml
                '''
            }
            post {
                always {
                    junit testResults: 'results/aggregated/xunit.xml', allowEmptyResults: true
                }
            }
        }
    }

    post {
        always {
            // Archive all results
            archiveArtifacts artifacts: 'results/**', allowEmptyArchive: true, fingerprint: true
            // Clean up workspace (optional, saves disk space)
            // cleanWs()
        }
        success {
            emailext(
                to: 'mageshaitest@gmail.com',
                subject: "SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """<p>Jenkins build completed successfully.</p>
<ul>
  <li>Job: ${env.JOB_NAME}</li>
  <li>Build: #${env.BUILD_NUMBER}</li>
  <li>Build URL: <a href='${env.BUILD_URL}'>${env.BUILD_URL}</a></li>
  <li>Git Commit: ${env.GIT_COMMIT}</li>
  <li>Branch: ${env.GIT_BRANCH}</li>
</ul>""",
                mimeType: 'text/html'
            )
        }
        failure {
            emailext(
                to: 'mageshaitest@gmail.com',
                subject: "FAILURE: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """<p>Jenkins build failed.</p>
<ul>
  <li>Job: ${env.JOB_NAME}</li>
  <li>Build: #${env.BUILD_NUMBER}</li>
  <li>Build URL: <a href='${env.BUILD_URL}'>${env.BUILD_URL}</a></li>
  <li>Git Commit: ${env.GIT_COMMIT}</li>
  <li>Branch: ${env.GIT_BRANCH}</li>
</ul>
<p>Check console output for details.</p>""",
                mimeType: 'text/html'
            )
        }
        unstable {
            emailext(
                to: 'mageshaitest@gmail.com',
                subject: "UNSTABLE: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """<p>Jenkins build unstable (tests failed but build continued).</p>
<ul>
  <li>Job: ${env.JOB_NAME}</li>
  <li>Build: #${env.BUILD_NUMBER}</li>
  <li>Build URL: <a href='${env.BUILD_URL}'>${env.BUILD_URL}</a></li>
</ul>""",
                mimeType: 'text/html'
            )
        }
    }
}
