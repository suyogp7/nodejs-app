pipeline {
    agent any

    environment {
        IMAGE_NAME = "suyog2306/nodejs-app"
        IMAGE_TAG  = "1.0"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    credentialsId: 'github-pat',
                    url: 'https://github.com/suyogp7/nodejs-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                        docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                    """
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                        export DOCKER_CONFIG=\$HOME/.docker
                        mkdir -p \$DOCKER_CONFIG
                        echo '{"credsStore":""}' > \$DOCKER_CONFIG/config.json

                        echo "\$DOCKER_PASS" | docker login -u "\$DOCKER_USER" --password-stdin
                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    """
                }
            }
        }

        stage('Deploy with Helm') {
            steps {
                script {
                    sh """
                        helm upgrade --install nodejs-app ./helm-chart \
                            --set image.repository=${IMAGE_NAME} \
                            --set image.tag=${IMAGE_TAG}
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful!"
        }
        failure {
            echo "❌ Build failed. Check console output."
        }
    }
}

