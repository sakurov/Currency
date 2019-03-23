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
                githubNotify account: 'bohdankoshyrets', 
                             credentialsId: 'bohdankoshyrets-github',
                             description: 'lol', 
                             repo: 'Currency', 
                             sha: env.GIT_COMMIT, 
                             status: 0, 
                             targetUrl: env.RUN_DISPLAY_URL
            }    
        }
    }
}
