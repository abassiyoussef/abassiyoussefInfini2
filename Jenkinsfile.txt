pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "abassinho/student-management:1.0"
        DOCKERHUB_CREDENTIALS = "dockerhub-credentials-id" // ID Jenkins pour Docker Hub
    }

    stages {
        stage('Build') {
            steps {
                echo 'Build stage: Compilation du projet'
                sh 'mvn clean install -DskipTests=true'
            }
        }

        stage('Test') {
            steps {
                echo 'Test stage: Exécution des tests unitaires'
                script {
                    def result = sh(script: 'mvn test', returnStatus: true)
                    if (result != 0) {
                        echo "Attention : certains tests ont échoué. Consultez target/surefire-reports"
                    }
                }
            }
        }

        stage('Post-Test') {
            steps {
                echo 'Post-Test: Analyse des résultats et copie des rapports'
                sh 'cp -r target/surefire-reports $WORKSPACE/surefire-reports || true'
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Docker Build: Construction de l’image Docker'
                sh "docker build --pull -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Docker Push') {
            steps {
                echo 'Docker Push: Envoi de l’image sur Docker Hub'
                script {
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKERHUB_CREDENTIALS}") {
                        sh "docker push ${DOCKER_IMAGE}"
                    }
                }
            }
        }

        stage('Cleanup') {
            steps {
                echo 'Cleanup: Suppression de l’image Docker locale pour libérer de l’espace'
                sh "docker rmi ${DOCKER_IMAGE} || true"
            }
        }
    }

    post {
        always {
            echo 'Pipeline terminé. Vérifiez les logs pour les tests et le push Docker.'
        }
        success {
            echo 'Pipeline exécuté avec succès !'
        }
        failure {
            echo 'Pipeline échoué. Consultez les logs pour identifier les erreurs.'
        }
    }
}
