pipeline {
    agent any

    stages {
        stage('Build and Push') {
            steps {
                script {
                    def dockerImage = 'kuzma343'
                    def dockerTag = 'alpine-6.2-latest'
                    def repoName = 'zabbixrepo'

                    // Build and push zabbix-agent container
                    docker.build("${dockerImage}/zabbix-agent:${dockerTag}", "--build-arg ZABBIX_VERSION=6.2 ${dockerImage}/zabbix-agent:${dockerTag}")
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        docker.image("${dockerImage}/zabbix-agent:${dockerTag}").push()
                    }

                    // Build and push mariadb container
                    docker.build("${dockerImage}/mariadb:${dockerTag}", "${dockerImage}/mariadb:${dockerTag}")
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        docker.image("${dockerImage}/mariadb:${dockerTag}").push()
                    }

                    // Build and push zabbix-server-mysql container
                    docker.build("${dockerImage}/zabbix-server-mysql:${dockerTag}", "--build-arg ZABBIX_VERSION=6.2 ${dockerImage}/zabbix-server-mysql:${dockerTag}")
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        docker.image("${dockerImage}/zabbix-server-mysql:${dockerTag}").push()
                    }

                    // Build and push zabbix-web-nginx-mysql container
                    docker.build("${dockerImage}/zabbix-web-nginx-mysql:${dockerTag}", "--build-arg ZABBIX_VERSION=6.2 ${dockerImage}/zabbix-web-nginx-mysql:${dockerTag}")
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        docker.image("${dockerImage}/zabbix-web-nginx-mysql:${dockerTag}").push()
                    }
                }
            }
        }
    }
}
