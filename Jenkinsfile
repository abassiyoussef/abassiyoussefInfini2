pipeline {
    agent any

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
    }

    post {
        always {
            echo 'Pipeline terminé. Vérifiez les logs pour les tests échoués.'
        }
    }
}
