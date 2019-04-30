def label = "mypod"

properties([parameters([choice(choices: ['terraform apply'], description: 'apply', name: 'apply')])])

podTemplate(label: label, containers: [
  containerTemplate(name: 'python-alpine', image: 'python:3-alpine', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'zip', image: 'kramos/alpine-zip', command: 'cat', ttyEnabled: true)
])
{
    node(label)
    {
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