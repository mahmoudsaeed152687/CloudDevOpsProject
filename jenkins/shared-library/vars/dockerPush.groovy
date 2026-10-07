def call(String imageName, String tag, String ecrRepository) {
    sh """
        docker tag ${imageName}:${tag} ${ecrRepository}:${tag}
        docker push ${ecrRepository}:${tag}
    """
}