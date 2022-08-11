pipeline {
    agent none
    stages {
        stage('Build') {
            agent any
            steps {
                checkout scm
                sh 'echo Hello'
                sh 'maven compile .'
            }
        }
        stage('Test on Linux') {
            agent { 
                label 'linux'
            }
            steps {
                unstash 'app' 
                sh 'make check'
            }
            post {
                always {
                    junit '**/target/*.xml'
                }
            }
        }
    }
}
