pipeline {
    agent any

    stages {
        stage ("Pull project") {
            steps {
                checkout scm
            }
        }
        
        stage("Print echo") {
            steps {
                echo hola
            }
        }
    }
}
