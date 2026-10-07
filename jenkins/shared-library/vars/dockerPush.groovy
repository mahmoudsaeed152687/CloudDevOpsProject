def call(String imageName, String tag, String ecrRepository) {
    def registry = ecrRepository.split('/')[0]

    sh """
        aws ecr get-login-password --region us-east-1 | \
        docker login --username AWS --password-stdin ${registry}

        docker tag ${imageName}:${tag} ${ecrRepository}:${tag}

        docker push ${ecrRepository}:${tag}
    """
}