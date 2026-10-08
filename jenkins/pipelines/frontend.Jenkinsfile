@Library('ivolve-shared-library') _

pipeline {
    agent any

    environment {
        SERVICE_NAME = 'frontend'
        IMAGE_NAME   = 'ivolve-frontend'
        IMAGE_TAG    = "${BUILD_NUMBER}"
        ECR_REPO     = '509989879328.dkr.ecr.us-east-1.amazonaws.com/ivolve-frontend'
        MANIFEST     = 'k8s/frontend/deployment.yaml'
    }

    stages {
        stage('Build Image') {
            steps {
                dockerBuild("${SERVICE_NAME}", "${IMAGE_NAME}", "${IMAGE_TAG}")
            }
        }

        stage('Check Dependencies') {
    steps {
        sh '''
            docker run --rm ${IMAGE_NAME}:${IMAGE_TAG} \
            npm ls brace-expansion http-cache-semantics ip-address pacote picomatch sigstore
        '''
    }
}

        stage('Push Image') {
            steps {
                dockerPush("${IMAGE_NAME}", "${IMAGE_TAG}", "${ECR_REPO}")
            }
        }

        stage('Delete Local Image') {
            steps {
                dockerCleanup("${IMAGE_NAME}", "${IMAGE_TAG}", "${ECR_REPO}")
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