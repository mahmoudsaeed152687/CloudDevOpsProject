def call(String imageName, String tag) {
    sh "trivy image --db-repository ghcr.io/aquasecurity/trivy-db --exit-code 0 --severity HIGH,CRITICAL ${imageName}:${tag}"
}