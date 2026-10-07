def call(String manifestFile, String ecrRepository, String tag) {
    sh """
        sed -i -E 's|image:.*|image: ${ecrRepository}:${tag}|' ${manifestFile}
    """
}