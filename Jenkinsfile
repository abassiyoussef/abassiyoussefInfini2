pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "abassinho/student-management:1.0"
    }

    stages {
        stage('Build') {
            steps {
                sh 'mvn clean install -DskipTests=true'
            }
        }

        stage('Docker Build & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        docker build -t ${DOCKER_IMAGE} .
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push ${DOCKER_IMAGE}
                    """
                }
            }
        }

        stage('Kubernetes Deploy') {
            steps {
                sh "kubectl apply -f student-k8s/mysql/"
                sh "kubectl apply -f student-k8s/springboot/"
                sh 'kubectl get pods -o wide'
            }
        }

        stage('Docker Cleanup') {
            steps {
                sh "docker rmi ${DOCKER_IMAGE} || true"
            }
        }
    }

    post {
        always {
            echo 'Pipeline terminé.'
        }
    }
}
