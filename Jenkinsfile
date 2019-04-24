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

            //stage("run unit test to app"){
            //    container("python-alpine"){
            //        sh "python --version"
            //        sh "python unit-test.py"
            //    }
            //}


            stage('Checkout Terraform') {
                container('terraform'){
                withCredentials([file(credentialsId: 'terraform', variable: 'GOOGLE_CREDENTIALS'),
                                 string(credentialsId: 'TF_VAR_password', variable: 'TF_VAR_password'),
                                 string(credentialsId: 'TF_VAR_api_telegram', variable: 'TF_VAR_api_telegram'),
                                 string(credentialsId: 'TF_VAR_MONGODB_PASSWORD', variable: 'TF_VAR_MONGODB_PASSWORD'),
                                 string(credentialsId: 'TF_VAR_API', variable: 'TF_VAR_API'),
                                 string(credentialsId: 'TF_VAR_bucket', variable: 'TF_VAR_bucket'),
                                 string(credentialsId: 'TF_VAR_project', variable: 'TF_VAR_project'),
                                 string(credentialsId: 'TF_VAR_MONGODB_ROOT_PASSWORD', variable: 'TF_VAR_MONGODB_ROOT_PASSWORD')
                             ]) {
                //set SECRET with the credential content
                    sh 'env'
                    sh 'ls -al $GOOGLE_CREDENTIALS'
                    echo "My secret text is '${GOOGLE_CREDENTIALS}'"
                    sh 'mkdir -p creds'
                    sh "cp \$GOOGLE_CREDENTIALS ./creds/d3tf-b894abb5e1c0.json"
                    sh 'terraform init'
                    //sh 'terraform plan -out myplan'
                    //sh 'terraform apply -auto-approve -input=false myplan'
                    sh 'terraform destroy'
                }
                }
            }





        }
        catch(err){
            currentBuild.result = 'Failure'
        }
    }
}