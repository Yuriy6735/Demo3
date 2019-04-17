def label = "mypod"


podTemplate(label: label, containers: [
  containerTemplate(name: 'python-alpine', image: 'python:3-alpine', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'zip', image: 'kramos/alpine-zip', command: 'cat', ttyEnabled: true)
], serviceAccount: "jenkins")
{

    node(label)
    {
        try {
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