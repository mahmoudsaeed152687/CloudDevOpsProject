def call(String imageName, String tag) {
    sh "trivy image --exit-code 1 --severity HIGH,CRITICAL ${imageName}:${tag}"
}