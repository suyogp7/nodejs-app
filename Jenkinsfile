pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "nodejs-app:latest"
        DOCKER_HUB_REPO = "suyogdocker/nodejs-app"
        DOCKER_CREDENTIALS = "dockerhub-creds"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/suyog-devops/nodejs-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: "$DOCKER_CREDENTIALS", usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                    sh 'docker tag $DOCKER_IMAGE $DOCKER_HUB_REPO'
                    sh 'docker push $DOCKER_HUB_REPO'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'helm upgrade --install nodejs-app ./helm --set image.repository=$DOCKER_HUB_REPO --set image.tag=latest'
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully!"
        }
        failure {
            echo "❌ Pipeline failed. Check logs."
        }
    }
}
