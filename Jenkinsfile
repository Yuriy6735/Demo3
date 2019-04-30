pipeline {
  agent {
    kubernetes {
      label 'mypod'
      defaultContainer 'jnlp'
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    some-label: some-label-value
spec:
  containers:
  - name: python
    image: python
    command:
    - cat
    tty: true
  - name: zip
    image: kramos/alpine-zip
    command:
    - cat
    tty: true
  - name: terraform
    image: hashicorp/terraform
    command:
    - cat
    tty: true
"""
    }
  }

  environment {
    SVC_ACCOUNT_KEY = credentials('terraform-auth')
  }

  stages {

    stage('Clone repo') {
      steps {
      checkout([$class: 'GitSCM', branches: [[name: '*/test1']],
        userRemoteConfigs: [[url: 'https://github.com/Yuriy6735/Demo3.git']]])
      }
    }
    stage("python"){
      steps {
      container("python"){
        sh "python --version"

        }
      }
    }

    stage("zip"){
      steps {
      container('zip'){

        sh "zip -v"
        }
      }
    }

  }
}