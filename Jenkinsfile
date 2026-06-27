pipeline {
    agent any

    environment {
        IMAGE_NAME = "suyog2306/nodejs-app"
        IMAGE_TAG  = "1.0"
        KUBE_NAMESPACE = "default"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    credentialsId: 'github-pat',   // Jenkins credential ID for GitHub PAT
                    url: 'https://github.com/suyogp7/nodejs-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',   // Jenkins credential ID for Docker Hub PAT
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        docker login -u $DOCKER_USER -p $DOCKER_PASS
                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Deploy with Helm') {
            steps {
                sh '''
                    helm upgrade --install nodejs-app ./helm-chart \
                        --namespace ${KUBE_NAMESPACE} \
                        --set image.repository=${IMAGE_NAME} \
                        --set image.tag=${IMAGE_TAG}
                '''
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
