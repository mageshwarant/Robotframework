pipeline {
    agent any

    tools {
        maven 'Maven'
    }

    options {
        timestamps()
        timeout(time: 60, unit: 'MINUTES')
        buildDiscarder(logRotator(numToKeepStr: '20', artifactNumToKeepStr: '10'))
    }

    environment {
        YAHOO_HEADLESS = 'true'
        VENV_DIR = 'venv'
        MAVEN_OPTS = '-Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Check Branch') {
            steps {
                script {
                    def branch = env.BRANCH_NAME ?: env.GIT_BRANCH ?: env.BRANCH
                    def branchName = branch?.tokenize('/')?.last()
                    if (branchName != 'test') {
                        error("Branch is '${branch}', not 'test'. Aborting build.")
                    }
                    echo "Branch is '${branch}'. Proceeding with build."
                }
            }
        }

        stage('Validate Environment') {
            steps {
                script {
                    bat '''
                        echo "=== Environment Validation ==="
                        java -version
                        mvn -version
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
                                    mvn -B -Pyahoo verify
                                '''
                            }
                        }
                    }
                }
                stage('API Tests') {
                    steps {
                        bat '''
                            echo "=== Running API Tests ==="
                            mvn -B -Papi verify
                        '''
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
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'results/**', allowEmptyArchive: true, fingerprint: true
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
</ul>
<p>Test reports are attached.</p>""",
                mimeType: 'text/html',
                attachmentsPattern: 'results/FirstProgram/report.html,results/apitest/report.html,results/aggregated/xunit.xml'
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
<p>Check console output for details. Test reports are attached.</p>""",
                mimeType: 'text/html',
                attachmentsPattern: 'results/FirstProgram/report.html,results/apitest/report.html,results/aggregated/xunit.xml'
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
</ul>
<p>Test reports are attached.</p>""",
                mimeType: 'text/html',
                attachmentsPattern: 'results/FirstProgram/report.html,results/apitest/report.html,results/aggregated/xunit.xml'
            )
        }
    }
}
