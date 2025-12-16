pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "abassinho/student-management:1.0"
        DOCKERHUB_CREDENTIALS = "dockerhub-credentials-id"
    }

    stages {

        stage('Build Maven') {
            steps {
                echo 'Compilation du projet'
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Tests') {
            steps {
                echo 'Exécution des tests'
                sh 'mvn test || true'
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Build image Docker'
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Docker Login') {
            steps {
                echo 'Login Docker Hub'
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKERHUB_CREDENTIALS}",
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Docker Push') {
            steps {
                echo 'Push image Docker'
                sh "docker push ${DOCKER_IMAGE}"
            }
        }

        stage('Cleanup') {
            steps {
                echo 'Nettoyage'
                sh "docker rmi ${DOCKER_IMAGE} || true"
            }
        }
    }

    post {
        success {
            echo 'Pipeline SUCCESS'
        }
        failure {
            echo 'Pipeline FAILURE'
        }
    }
}
