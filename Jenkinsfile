pipeline {
  agent any
  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
  }
  stages {
    stage('Build Docker Image') {
      steps {
        sh 'docker build -t nodejs-app:1.0 .'
      }
    }
    stage('Push to Docker Hub') {
      steps {
        sh 'docker login -u $DOCKERHUB_CREDENTIALS_USR -p $DOCKERHUB_CREDENTIALS_PSW'
        sh 'docker tag nodejs-app:1.0 suyogp7/nodejs-app:1.0'
        sh 'docker push suyogp7/nodejs-app:1.0'
      }
    }
    stage('Deploy to Kubernetes via Helm') {
      steps {
        sh 'helm upgrade --install nodejs-app ./nodejs-app-chart --set image.repository=suyogp7/nodejs-app --set image.tag=1.0'
      }
    }
  }
}

