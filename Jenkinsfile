//  groovy Jenkinsfile
properties([disableConcurrentBuilds()])

pipeline {
    agent {
        label ''
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
        timestamps()
    }

    stages {
        stage('Build and Push') {
            steps {
                script {
                    def dockerImage = 'kuzma343/zabbixrepo:latest'

                    // Build and push Zabbix Agent image
                    docker.build("kuzma343/zabbix-agent:alpine-6.2-latest").push()

                    // Build and push MariaDB image
                    docker.build("kuzma343/mariadb:10.5").push()

                    // Build and push Zabbix Server image
                    docker.build("kuzma343/zabbix-server-mysql:alpine-6.2-latest").push()

                    // Build and push Zabbix Web image
                    docker.build("kuzma343/zabbix-web-nginx-mysql:alpine-6.2-latest").push()

                    // Build and push the combined image
                    def dockerfileContent = """
                        FROM kuzma343/zabbix-agent:alpine-6.2-latest
                        COPY --from=kuzma343/mariadb:10.5 / /
                        COPY --from=kuzma343/zabbix-server-mysql:alpine-6.2-latest / /
                        COPY --from=kuzma343/zabbix-web-nginx-mysql:alpine-6.2-latest / /
                    """

                    docker.withRegistry('', 'dockerhub') {
                        docker.image(dockerImage).withBuild { build ->
                            build.pull()
                            build.dockerfileContent = dockerfileContent
                        }
                        docker.image(dockerImage).push()
                    }
                }
            }
        }
    }

}

