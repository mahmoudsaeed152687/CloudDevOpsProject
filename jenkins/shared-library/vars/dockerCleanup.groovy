def call(String imageName, String tag, String ecrRepository) {
    sh """
        docker rmi ${imageName}:${tag} || true
        docker rmi ${ecrRepository}:${tag} || true
    """
}