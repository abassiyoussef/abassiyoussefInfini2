pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "abassinho/student-management:1.0"
        DOCKERHUB_CREDENTIALS = "dockerhub-token" // L'ID du token déjà enregistré dans Jenkins
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

        stage('Docker Build & Push') {
            steps {
                echo 'Docker Build & Push: Construction et envoi de l’image Docker'
                script {
                    withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh """
                            docker build --pull -t ${DOCKER_IMAGE} .
                            echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin
                            docker push ${DOCKER_IMAGE}
                        """
                    }
                }
            }
        }

        stage('Kubernetes Deploy') {
            steps {
                echo 'Déploiement sur Kubernetes'
                sh "kubectl apply -f student-k8s/mysql/"
                sh "kubectl apply -f student-k8s/springboot/"
                sh 'kubectl get pods -o wide'
                sh 'kubectl get svc -o wide'
            }
        }

        stage('Docker Cleanup') {
            steps {
                echo 'Cleanup: Suppression de l’image Docker locale'
                sh "docker rmi ${DOCKER_IMAGE} || true"
            }
        }
    }

    post {
        always {
            echo 'Pipeline terminé. Vérifiez les logs pour les tests, le push Docker et le déploiement Kubernetes.'
        }
        success {
            echo 'Pipeline exécuté avec succès !'
        }
        failure {
            echo 'Pipeline échoué. Consultez les logs pour identifier les erreurs.'
        }
    }
}
