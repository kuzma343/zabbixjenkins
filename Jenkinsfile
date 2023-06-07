pipeline {
    agent any

    stages {
        stage('Build and Push') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        def agentImage = docker.image('kuzma343/zabbix-agent:alpine-6.2-latest')
                        def mariadbImage = docker.image('kuzma343/mariadb:10.5')
                        def serverImage = docker.image('kuzma343/zabbix-server-mysql:alpine-6.2-latest')
                        def webImage = docker.image('kuzma343/zabbix-web-nginx-mysql:alpine-6.2-latest')
                        def repoImage = docker.image('kuzma343/zabbixrepo')

                        def agentContainer = agentImage.run()
                        def mariadbContainer = mariadbImage.run()
                        def serverContainer = serverImage.run(linkedContainers: [mariadbContainer])
                        def webContainer = webImage.run(linkedContainers: [mariadbContainer, serverContainer])

                        // Зупинити і видалити попередні контейнери з репозиторію Docker Hub
                        repoImage.inside {
                            sh 'docker stop $(docker ps -a -q)'
                            sh 'docker rm $(docker ps -a -q)'
                        }

                        // Створити образ з об'єднаними контейнерами
                        def mergedImage = docker.build('kuzma343/zabbixrepo')
                        mergedImage.push()

                        // Зупинити і видалити тимчасові контейнери
                        agentContainer.stop()
                        agentContainer.remove()
                        mariadbContainer.stop()
                        mariadbContainer.remove()
                        serverContainer.stop()
                        serverContainer.remove()
                        webContainer.stop()
                        webContainer.remove()
                    }
                }
            }
        }
    }
}
