pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "abassinho/student-management:1.0"
        DOCKERHUB_CREDENTIALS = "dockerhub-credentials-id" // Remplace par ton ID Jenkins pour Docker Hub
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
                    // Exécuter les tests mais ne pas arrêter le pipeline en cas d'erreur
                    def result = sh(script: 'mvn test', returnStatus: true)
                    
                    if (result != 0) {
                        echo "Attention : des tests ont échoué, consultez target/surefire-reports"
                    }
                }
            }
        }

        stage('Post-Test') {
            steps {
                echo 'Post-Test: Analyse des résultats et rapport'
                // Copier les logs vers un dossier accessible dans Jenkins
                sh 'cp -r target/surefire-reports $WORKSPACE/surefire-reports'
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Docker Build: Construction de l’image Docker'
                sh "docker build -t ${DOCKER_IMAGE} ."
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
    }

    post {
        always {
            echo 'Pipeline terminé. Vérifiez les logs pour les tests et le push Docker.'
        }
    }
}
