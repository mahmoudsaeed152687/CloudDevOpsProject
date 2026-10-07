def call(String imageName, String tag) {
    sh "docker rmi ${imageName}:${tag} || true"
}