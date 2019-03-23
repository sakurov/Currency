pipeline {
    agent any

    stages {
        stage ("Pull project") {
            steps {
                echo "hello"
                step([$class: 'GitHubCommitStatusSetter',
                    contextSource: [$class: 'ManuallyEnteredCommitContextSource', context: 'Build'],
                    statusResultSource: [$class: 'ConditionalStatusResultSource',
                    results: [[$class: 'AnyBuildResult', message: 'Building on Jenkins CI', state: 'PENDING']]]]
                    )
                step([$class: 'GitHubCommitStatusSetter',
                    contextSource: [$class: 'ManuallyEnteredCommitContextSource', context: 'Test'],
                    statusResultSource: [$class: 'ConditionalStatusResultSource',
                    results: [[$class: 'AnyBuildResult', message: 'Testing on Jenkins CI', state: 'PENDING']]]]
                    )
                step([$class: 'GitHubCommitStatusSetter',
                    contextSource: [$class: 'ManuallyEnteredCommitContextSource', context: 'Integration'],
                    statusResultSource: [$class: 'ConditionalStatusResultSource',
                    results: [[$class: 'AnyBuildResult', message: 'Integrating on Jenkins CI', state: 'PENDING']]]]
                    )
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
            setBuildStatus("Build cocks", "PENDING");
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
