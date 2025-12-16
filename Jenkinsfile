pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Build stage: Compilation du projet'
                sh 'mvn clean install'
            }
        }
        stage('Test') {
            steps {
                echo 'Test stage: Exécution des tests'
                sh 'mvn test'
            }
        }
    }
}
