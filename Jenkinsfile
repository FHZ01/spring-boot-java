pipeline {
    agent none
    stages {
        stage('Build') {
            agent any
            steps {
                checkout scm
                sh 'echo Hello'
                sh '/opt/apache-maven-3.8.1/bin/mvn validate'
            }
        }
        stage('Test on Linux') {
            agent any  
            steps {
                ls -ltrh ./src
            }
            post {
                always {
                    junit '**/target/*.xml'
                }
            }
        }
    }
}
