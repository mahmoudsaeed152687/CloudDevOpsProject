def call(String serviceName) {
    sh """
        git add .
        git commit -m "Update ${serviceName} image"
        git push origin main
    """
}