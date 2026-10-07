def call(String serviceName, String imageName, String tag) {
    sh """
        docker build \
          -t ${imageName}:${tag} \
          ./${serviceName}
    """
}