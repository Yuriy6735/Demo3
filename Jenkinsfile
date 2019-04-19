def label = "mypod"


podTemplate(label: label, containers: [
  containerTemplate(name: 'python-alpine', image: 'python:3-alpine', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'zip', image: 'kramos/alpine-zip', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'terraform', image: 'hashicorp/terraform', command: 'cat', ttyEnabled: true)
])
{

    node(label)
    {
        try {



           //withEnv(["SVC_ACCOUNT_KEY = credentials('terraform-auth')"]){
           //     stage('Build'){
           //         sh 'printenv'
           //         sh 'echo ${SVC_ACCOUNT_KEY}'
           //     }
           //}

                //stage('Deps') {
                //    env.SVC_ACCOUNT_KEY = credentials('terraform-auth')
                //    sh 'echo SVC_ACCOUNT_KEY'
                //}

                stage('Clone repo'){
                    //git url: 'https://github.com/Yuriy6735/Demo3.git'
                    checkout([$class: 'GitSCM', branches: [[name: '*/test1']],
                        userRemoteConfigs: [[url: 'https://github.com/Yuriy6735/Demo3.git']]])
                    }

                stage("run in one container"){
                    container("python-alpine"){
                        sh "python --version"
                        sh "python unit-test.py"
                        // and other commands to run
                    }
                }

                stage("run in other container"){
                    container('zip'){

                        sh "zip -v"
                        sh "zip -j app.zip main.py requirements.txt"
                    }
                }



                stage('Checkout') {
                    container('terraform'){
                    withCredentials([file(credentialsId: 'terraform', variable: 'SVC_ACCOUNT_KEY')]) {
                    //set SECRET with the credential content
                        sh 'ls -al $SVC_ACCOUNT_KEY'
                        echo "My secret text is '${SVC_ACCOUNT_KEY}'"
                    }
                    //checkout scm
                    //sh 'mkdir -p creds'
                    sh "cp \$SVC_ACCOUNT_KEY /creds/serviceaccount.json"
                    }
                }

                stage('TF Plan') {
                    container('terraform') {
                      sh 'terraform init'
                      sh 'terraform plan -out myplan'

                    }
                }

                //stage('Approval') {
                //  steps {
                //    script {
                //      def userInput = input(id: 'confirm', message: 'Apply Terraform?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Apply terraform', name: 'confirm'] ])
                //    }
                //  }
                //}

                stage('TF Apply') {
                    container('terraform') {
                      sh 'terraform apply -input=false myplan'
                    }

                }






        }
        catch(err){
            currentBuild.result = 'Failure'
        }
    }
}