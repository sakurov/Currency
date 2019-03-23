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
            setBuildStatus("Build very good build", "SUCCESS");
        }
    }
}
