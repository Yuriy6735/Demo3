#!groovy

pipeline {
    agent any
    stages {
        stage('build') {
            steps {
                sh 'python unit-test.py'
            }
        }
    }
}