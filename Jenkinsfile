@Library('AI_agents_for_CI_shared_library') _

pipeline {
    agent {
        node {
            label 'linux'
            customWorkspace "/var/jenkins_home/workspace/${env.JOB_NAME}/${env.BUILD_NUMBER}"
        }
    }

    options {
        skipDefaultCheckout(true)
    }

    tools {
        nodejs '25.6.1'
        dockerTool 'Docker-v27.3.1'
    }

    environment {
        SONARQUBE_TOKEN = credentials('SONARQUBE_TOKEN')
        SONARQUBE_URL = 'http://sonarqube:9000'
        SONARQUBE_PROJECT_KEY = 'polyglot-order-toolkit'
        LLM_API_KEY_VALUE = credentials('LLM_API_KEY_VALUE')
        Github_AI_Auth = credentials('Github_AI_Auth')
        AI_REPORTS_DIR = 'reports_for_IA'
        DOCKER_HOST = 'tcp://host.docker.internal:2375'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Prepare AI Directory') {
            steps {
                sh '''
                    rm -rf "$AI_REPORTS_DIR"
                    mkdir -p "$AI_REPORTS_DIR"
                '''
            }
        }

        stage('Compile Java') {
            when {
                expression { env.CHANGE_ID }
            }
            steps {
                sh '''
                    rm -rf "$WORKSPACE/build/java/classes"
                    mkdir -p "$WORKSPACE/build/java/classes"
                    javac -d "$WORKSPACE/build/java/classes" \
                      "$WORKSPACE/src/java/com/example/order/OrderRiskRules.java"
                '''
            }
        }

        stage('Install Python Dependencies') {
            when {
                expression { env.CHANGE_ID && (env.CHANGE_BRANCH ?: '').startsWith('ai-fix/') }
            }
            steps {
                sh '''
                    python3 -m pip install --break-system-packages -r "$WORKSPACE/requirements/python_requirements.txt" > /dev/null 2>&1 || exit 0
                '''
            }
        }

        stage('Run Tests') {
            when {
                expression { env.CHANGE_ID && (env.CHANGE_BRANCH ?: '').startsWith('ai-fix/') }
            }
            steps {
                script {
                    def failedSuites = []

                    int pythonStatus = sh(
                        script: "PYTHONPATH=\"$WORKSPACE/src/python\" python3 -m pytest \"$WORKSPACE/tests/python/test_order_totals.py\" --json-report --json-report-file=\"$WORKSPACE/$AI_REPORTS_DIR/python_test_results.json\" > /dev/null 2>&1",
                        returnStatus: true
                    )
                    if (pythonStatus != 0) {
                        failedSuites << 'python'
                    }

                    int jsStatus = sh(
                        script: "node --test --test-reporter=junit --test-reporter-destination=\"$WORKSPACE/$AI_REPORTS_DIR/js_test_results.xml\" tests/javascript/test_order_validator.js > /dev/null 2>&1",
                        returnStatus: true
                    )
                    if (jsStatus != 0) {
                        failedSuites << 'javascript'
                    }

                    int javaStatus = sh(
                        script: "bash \"$WORKSPACE/scripts/run_java_tests.sh\" > \"$WORKSPACE/$AI_REPORTS_DIR/java_test_results.txt\" 2>&1",
                        returnStatus: true
                    )
                    if (javaStatus != 0) {
                        failedSuites << 'java'
                    }

                    archiveArtifacts artifacts: "${env.AI_REPORTS_DIR}/*", fingerprint: true, allowEmptyArchive: true

                    if (failedSuites) {
                        error("Test suites failed: ${failedSuites.join(', ')}")
                    }
                }
            }
        }

        stage('Scan') {
            when {
                expression { env.CHANGE_ID && !((env.CHANGE_BRANCH ?: '').startsWith('ai-fix/')) }
            }
            steps {
                script {
                    def safeBranch = (env.BRANCH_NAME ?: 'manual').replaceAll(/[^A-Za-z0-9._:-]/, '_')
                    env.SONARQUBE_EFFECTIVE_PROJECT_KEY = "${env.SONARQUBE_PROJECT_KEY}:${safeBranch}"
                }
                withSonarQubeEnv(installationName: 'sonarQube_server') {
                    sh '''
                        echo "Scanning with project key: ${SONARQUBE_EFFECTIVE_PROJECT_KEY}"

                        sonar-scanner \
                        -Dsonar.projectKey="${SONARQUBE_EFFECTIVE_PROJECT_KEY}" \
                        -Dsonar.sources=src \
                        -Dsonar.tests=tests \
                        -Dsonar.java.binaries="$WORKSPACE/build/java/classes" \
                        -Dsonar.host.url=$SONARQUBE_URL \
                        -Dsonar.login=$SONARQUBE_TOKEN \
                        -Dsonar.scanner.metadataFilePath="$WORKSPACE/report-task.txt" > /dev/null 2>&1
                    '''
                }
            }
        }

        stage('Quality Gate') {
            when {
                expression { env.CHANGE_ID && !((env.CHANGE_BRANCH ?: '').startsWith('ai-fix/')) }
            }
            steps {
                script {
                    waitForQualityGate abortPipeline: false
                }
            }
        }

        stage('Fix Issues with AI') {
            when {
                expression { env.CHANGE_ID && !((env.CHANGE_BRANCH ?: '').startsWith('ai-fix/')) }
            }
            steps {
                echo "Attempting to fix issues with AI..."
                FixWithAI(
                    llmModel: 'gemini-3.1-pro-preview',
                    llmCredentialId: 'LLM_API_KEY_VALUE',
                    githubCredentialId: 'Github_AI_Auth',
                    repoSlug: 'PabloMartinezIbanez/polyglot-order-toolkit',
                    testConfigFile: 'ai-tests-config.json',
                    dryRun: false
                )
            }
        }
    }

    post {
        always {
            cleanWs(
                cleanWhenSuccess: true,
                cleanWhenFailure: false,
                deleteDirs: true
            )
        }
    }
}
