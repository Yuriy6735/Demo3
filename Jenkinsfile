def label = "mypod"

properties([parameters([choice(choices: ['terraform apply'], description: 'apply', name: 'apply')])])

podTemplate(label: label, containers: [
  containerTemplate(name: 'python-alpine', image: 'python:3-alpine', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'zip', image: 'kramos/alpine-zip', command: 'cat', ttyEnabled: true)
])
{
    node(label)
    {
        withCredentials([file(credentialsId: 'terraform', variable: 'GOOGLE_CREDENTIALS'),
                                 string(credentialsId: 'TF_VAR_password', variable: 'TF_VAR_password'),
                                 string(credentialsId: 'TF_VAR_api_telegram', variable: 'TF_VAR_api_telegram'),
                                 string(credentialsId: 'TF_VAR_MONGODB_PASSWORD', variable: 'TF_VAR_MONGODB_PASSWORD'),
                                 string(credentialsId: 'TF_VAR_API', variable: 'TF_VAR_API'),
                                 string(credentialsId: 'TF_VAR_bucket', variable: 'TF_VAR_bucket'),
                                 string(credentialsId: 'TF_VAR_project', variable: 'TF_VAR_project'),
                                 string(credentialsId: 'TF_VAR_MONGODB_ROOT_PASSWORD', variable: 'TF_VAR_MONGODB_ROOT_PASSWORD')
                             ]) {
            try {
                stage('Clone repo'){
                    checkout([$class: 'GitSCM', branches: [[name: '*/test1']],
                        userRemoteConfigs: [[url: 'https://github.com/Yuriy6735/Demo3.git']]])
                    }

                stage("run in one container"){
                    container("python-alpine"){
                        sh "python --version"
                        // and other commands to run
                    }
                }
                stage("run in other container"){
                    container('zip'){
                        sh "zip -v"
                    }
                }
            }
            catch(err){
                currentBuild.result = 'Failure'
            }
    }
    }
}