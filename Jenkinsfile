def label = "jenpod"


podTemplate(label: label, containers: [
  containerTemplate(name: 'python-alpine', image: 'python:3-alpine', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'terraform', image: 'hashicorp/terraform', command: 'cat', ttyEnabled: true)
])
{

    node(label)
    {
        try {

            stage('Clone repo'){
                //git url: 'https://github.com/Yuriy6735/Demo3.git'
                checkout([$class: 'GitSCM', branches: [[name: '*/test1']],
                    userRemoteConfigs: [[url: 'https://github.com/Yuriy6735/Demo3.git']]])
                }

            stage("run unit test to app"){
                container("python-alpine"){
                    sh "python --version"
                    sh "python unit-test.py"
                }
            }


            stage('Checkout Terraform') {
                container('terraform'){
                withCredentials([file(credentialsId: 'terraform', variable: 'SVC_ACCOUNT_KEY')]) {
                //set SECRET with the credential content
                    sh 'ls -al $SVC_ACCOUNT_KEY'
                    echo "My secret text is '${SVC_ACCOUNT_KEY}'"
                    sh 'mkdir -p creds'
                    sh "cp \$SVC_ACCOUNT_KEY ./creds/first-project-7961f812579a.json"
                }
                }
            }

            stage('TF Plan') {
                container('terraform') {
                  sh 'terraform init'
                  sh 'terraform plan -out myplan'

                }
            }


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