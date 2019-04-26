def label = "jenpod"

properties([
    parameters([
        stringParam(
            defaultValue: 'v2.0',
            description: 'Current version',
            name: 'imageTagGET_'),
        stringParam(
            defaultValue: 'v2.0',
            description: 'Current version',
            name: 'imageTagUI_')
    ])
])

podTemplate(label: label, containers: [
  containerTemplate(name: 'python3', image: 'python:3', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'terraform', image: 'hashicorp/terraform', command: 'cat', ttyEnabled: true)
])
{

    node(label)
    {
        try {
            withCredentials([file(credentialsId: 'terraform', variable: 'GOOGLE_CREDENTIALS'),
                                 string(credentialsId: 'TF_VAR_password', variable: 'TF_VAR_password'),
                                 string(credentialsId: 'TF_VAR_api_telegram', variable: 'TF_VAR_api_telegram'),
                                 string(credentialsId: 'TF_VAR_MONGODB_PASSWORD', variable: 'TF_VAR_MONGODB_PASSWORD'),
                                 string(credentialsId: 'TF_VAR_API', variable: 'TF_VAR_API'),
                                 string(credentialsId: 'TF_VAR_bucket', variable: 'TF_VAR_bucket'),
                                 string(credentialsId: 'TF_VAR_project', variable: 'TF_VAR_project'),
                                 string(credentialsId: 'TF_VAR_MONGODB_ROOT_PASSWORD', variable: 'TF_VAR_MONGODB_ROOT_PASSWORD')
                             ]) {

                stage('Clone repo'){
                    //git url: 'https://github.com/Yuriy6735/Demo3.git'
                    checkout([$class: 'GitSCM', branches: [[name: '*/test1']],
                        userRemoteConfigs: [[url: 'https://github.com/Yuriy6735/Demo3.git']]])
                    }

                stage("run units test to app"){
                    container("python3"){
                        sh "pip3 install -r ./functions/requirements.txt"
                        sh "python3 --version"
                        sh "python3 ./functions/app/test.py"
                        sh "python3 ./functions/currentTemp/test.py"
                        sh "python3 ./functions/getFromDB/test.py"
                        sh "python3 ./functions/getPredictions/test.py"
                        sh "python3 ./functions/saveToDB/test.py"
                        sh "python3 ./functions/toZamb/test.py"
                        //sh "python3 ./functions/zamb/test.py"
                    }
                }




                stage('Checkout Terraform') {
                    container('terraform'){

                    //set SECRET with the credential content
                        sh 'ls -al $GOOGLE_CREDENTIALS'
                        echo "My secret text is '${GOOGLE_CREDENTIALS}'"
                        sh 'mkdir -p creds'
                        sh "cp \$GOOGLE_CREDENTIALS ./creds/d3tf-b894abb5e1c0.json"
                        sh 'terraform init'
                        sh 'terraform plan -out myplan'
                        //sh 'terraform apply -auto-approve -input=false myplan'
                        //sh 'terraform destroy -auto-approve -input=false'
                    }
                    }

                stage('Apply Terraform') {
                    container('terraform'){
                        sh 'terraform apply -auto-approve -input=false myplan'
                    }
                    }

                stage('Destroy Terraform?') {
                    container('terraform'){
                        //input 'Destroy Terraform?'
                    }
                    }

                stage('Terraform destroying') {
                    container('terraform'){
                        //sh 'terraform destroy -auto-approve -input=false'
                    }
                    }
            }





        }
        catch(err){
            currentBuild.result = 'Failure'
        }
    }
}