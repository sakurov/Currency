pipeline {
    agent any

    stages {
        stage ("Pull project") {
            steps {
                echo "hello"
            }
        }
        stage("Report result") {
            steps {
                echo "hello once again"
            }    
        }
    }
    post {
        success {
            setBuildStatus("Build rocks", "FAILURE");
        }
        failure {
            setBuildStatus("Build fucked up", "SUCCESS");
        }
    }
}

void setBuildStatus(String message, String state) {
  step([
      $class: "GitHubCommitStatusSetter",
      reposSource: [$class: "ManuallyEnteredRepositorySource", url: "https://github.com/bohdankoshyrets/Currency"],
      contextSource: [$class: "ManuallyEnteredCommitContextSource", context: "ci/jenkins/build-status"],
      errorHandlers: [[$class: "ChangingBuildStatusErrorHandler", result: "UNSTABLE"]],
      statusResultSource: [ $class: "ConditionalStatusResultSource", results: [[$class: "AnyBuildResult", message: message, state: state]] ]
  ]);
}
