def label = "mypod"


podTemplate(label: label, containers: [
  containerTemplate(name: 'python-alpine', image: 'python:3-alpine', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'zip', image: 'kramos/alpine-zip', command: 'cat', ttyEnabled: true)
])
{

    node(label)
    {
        try {
            stage('Clone repo'){
                git url: 'https://github.com/Yuriy6735/Demo3.git'
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
                    sh "zip -j test_jenkins.zip main.py requirements.txt"
                }
            }
        }
        catch(err){
            currentBuild.result = 'Failure'
        }
    }
}