pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        script {
          def GIT_URL = 'https://github.com/anandstomar/php-app.git'
          def GIT_BRANCH = 'main'
          git url: GIT_URL, branch: GIT_BRANCH
        }
      }
    }

    stage('Build') {
      steps {
        script {
          def DOCKER_REPO = 'anandst123/php-app'
          def IMAGE_TAG = currentBuild.number.toString()
          sh "docker build --no-cache -t ${DOCKER_REPO}:${IMAGE_TAG} ."
        }
      }
    }

    stage('Push to Docker Hub') {
      steps {
        script {
          def DOCKER_REPO = 'anandst123/php-app'
          def IMAGE_TAG = currentBuild.number.toString()
          def IMAGE_FULL = "${DOCKER_REPO}:${IMAGE_TAG}"

          withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
            sh """#!/bin/bash
set -euo pipefail

echo "[INFO] Logging into Docker Hub as ${DH_USER}"
echo "${DH_PASS}" | docker login --username "${DH_USER}" --password-stdin

echo "[INFO] Tagging image ${DOCKER_REPO}:${IMAGE_TAG} -> ${IMAGE_FULL}"
docker tag ${DOCKER_REPO}:${IMAGE_TAG} ${IMAGE_FULL}

echo "[INFO] Pushing ${IMAGE_FULL} to Docker Hub"
docker push ${IMAGE_FULL}

echo "[INFO] Push complete: ${IMAGE_FULL}"
"""
          }
        }
      }
    }

    stage('Deploy (run on Jenkins host)') {
      steps {
        script {
          def DOCKER_REPO = 'anandst123/php-app'
          def IMAGE_TAG = currentBuild.number.toString()
          def IMAGE_FULL = "${DOCKER_REPO}:${IMAGE_TAG}"

          withCredentials([
            usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS'),
            usernamePassword(credentialsId: 'db-creds', usernameVariable: 'DB_USER', passwordVariable: 'DB_PASS'),
            string(credentialsId: 'db-host', variable: 'DB_HOST'),
            string(credentialsId: 'db-name', variable: 'DB_NAME')
          ]) {
            sh """#!/bin/bash
set -euo pipefail

echo "[INFO] Logging into Docker Hub on Jenkins host as ${DH_USER}"
echo "${DH_PASS}" | docker login --username "${DH_USER}" --password-stdin

echo "[INFO] Pulling image ${IMAGE_FULL}"
docker pull ${IMAGE_FULL}

echo "[INFO] Removing old container (if any)"
docker rm -f php-simple || true

echo "[INFO] Starting container ${IMAGE_FULL} (DB endpoint hidden)"
docker run -d --name php-simple -p 80:80 \
  -e DB_HOST="${DB_HOST}" -e DB_NAME="${DB_NAME}" -e DB_USER="${DB_USER}" -e DB_PASS="${DB_PASS}" -e DB_PORT="5432" \
  --restart unless-stopped ${IMAGE_FULL}

echo "[INFO] Deployment finished. Container status:"
docker ps --filter name=php-simple --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
"""
          }
        }
      }
    }
  } // stages

  post {
    success {
      echo "Pipeline completed successfully. Image deployed."
    }
    failure {
      echo "Pipeline failed — check console output."
    }
  }
}
