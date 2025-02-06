pipeline {
  agent any

  environment {
    DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials') // Add Docker Hub credentials in Jenkins
    GITHUB_CREDENTIALS = credentials('github-credentials') // Add GitHub credentials in Jenkins
  }

  stages {
    stage('Checkout from GitHub') {
      steps {
        git branch: 'main', credentialsId: 'github-credentials', url: 'https://github.com/your-username/your-repo.git'
      }
    }

    stage('Build Frontend') {
      steps {
        dir('frontend') {
          sh 'npm install'
          sh 'npm run build'
          sh 'docker build -t your-dockerhub-username/my-frontend-image:latest .'
        }
      }
    }

    stage('Build Backend') {
      steps {
        dir('backend') {
          sh 'npm install'
          sh 'docker build -t your-dockerhub-username/my-backend-image:latest .'
        }
      }
    }

    stage('Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', passwordVariable: 'DOCKER_HUB_PASSWORD', usernameVariable: 'DOCKER_HUB_USERNAME')]) {
          sh 'echo $DOCKER_HUB_PASSWORD | docker login -u $DOCKER_HUB_USERNAME --password-stdin'
          sh 'docker push your-dockerhub-username/my-frontend-image:latest'
          sh 'docker push your-dockerhub-username/my-backend-image:latest'
        }
      }
    }

    stage('Security Scan with Trivy') {
      steps {
        sh 'trivy image your-dockerhub-username/my-frontend-image:latest'
        sh 'trivy image your-dockerhub-username/my-backend-image:latest'
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        sh 'kubectl apply -f kubernetes/'
      }
    }

    stage('Run OWASP ZAP Scan') {
      steps {
        sh 'docker run -v $(pwd):/zap/wrk/:rw -t owasp/zap2docker-stable zap-baseline.py -t http://your-app-url.com -r zap_report.html'
        archiveArtifacts artifacts: 'zap_report.html', allowEmptyArchive: true
      }
    }

    stage('SonarQube Analysis') {
      steps {
        withSonarQubeEnv('sonar-server') { // Configure SonarQube server in Jenkins
          sh 'sonar-scanner -Dsonar.projectKey=my-devops-project -Dsonar.sources=. -Dsonar.host.url=http://your-sonarqube-server:9000 -Dsonar.login=your-sonarqube-token'
        }
      }
    }
  }

  post {
    success {
      slackSend channel: '#devops', message: 'Pipeline succeeded!'
    }
    failure {
      slackSend channel: '#devops', message: 'Pipeline failed!'
    }
  }
}