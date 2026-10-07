@Library('ivolve-shared-library') _

pipeline {
    agent any

    environment {
        SERVICE_NAME = 'roadmap-service'
        IMAGE_NAME   = 'ivolve-roadmap-service'
        IMAGE_TAG    = "${BUILD_NUMBER}"
        ECR_REPO     = '509989879328.dkr.ecr.us-east-1.amazonaws.com/ivolve-roadmap-service'
        MANIFEST     = 'k8s/roadmap-service/deployment.yaml'
    }

    stages {
        stage('Build Image') {
            steps {
                dockerBuild("${SERVICE_NAME}", "${IMAGE_NAME}", "${IMAGE_TAG}")
            }
        }

        stage('Scan Image') {
            steps {
                trivyScan("${IMAGE_NAME}", "${IMAGE_TAG}")
            }
        }

        stage('Push Image') {
            steps {
                dockerPush("${IMAGE_NAME}", "${IMAGE_TAG}", "${ECR_REPO}")
            }
        }

        stage('Delete Local Image') {
            steps {
                dockerCleanup("${IMAGE_NAME}", "${IMAGE_TAG}")
            }
        }

        stage('Update Manifest') {
            steps {
                updateManifest("${MANIFEST}", "${ECR_REPO}", "${IMAGE_TAG}")
            }
        }

        stage('Push Manifest') {
            steps {
                pushManifests("${SERVICE_NAME}")
            }
        }
    }
}