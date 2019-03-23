pipeline {
    agent any

    stages {
        stage ("Pull project") {
            steps {
                echo "hello"
                setBuildStatus("Build cocks", "PENDING");
                wait(100)
            }
        }
        stage("Report result") {
            steps {
                echo "hello once again"
            }    
        }
    }
}

void setBuildStatus(String message, String state) {
  step([
      $class: "GitHubCommitStatusSetter",
      reposSource: [$class: "ManuallyEnteredRepositorySource", url: "https://github.com/bohdankoshyrets/Currency"],
      contextSource: [$class: "ManuallyEnteredCommitContextSource", context: "Status"],
      errorHandlers: [[$class: "ChangingBuildStatusErrorHandler", result: "UNSTABLE"]],
      statusResultSource: [ $class: "ConditionalStatusResultSource", results: [[$class: "AnyBuildResult", message: message, state: state]] ]
  ]);
}
