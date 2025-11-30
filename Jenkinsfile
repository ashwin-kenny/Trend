pipeline {
    agent any

    triggers {
        // Enables GitHub webhook trigger
        githubPush()
    }

    stages {
        stage('Verify Trigger') {
            steps {
                echo "🎉 Jenkins pipeline triggered by GitHub push !"

                echo "Branch: ${env.GIT_BRANCH}"
                echo "Commit ID: ${env.GIT_COMMIT}"
                
                script {
                    def msg = sh(
                        script: "git log -1 --pretty=%B",
                        returnStdout: true
                    ).trim()
                    echo "Last Commit Message: ${msg}"
                }
            }
        }
    }
}
