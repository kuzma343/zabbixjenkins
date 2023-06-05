pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                script {
                    // Завантаження образів Docker
                    docker.image('kuzma343/mariadb:10.5').pull()
                    docker.image('kuzma343/zabbix-agent:alpine-6.2-latest').pull()
                    docker.image('kuzma343/zabbix-server-mysql:alpine-6.2-latest').pull()
                    docker.image('kuzma343/zabbix-web-nginx-mysql:alpine-6.2-latest').pull()
                }
            }
        }
        
        stage('Run Containers') {
            steps {
                script {
                    // Запуск контейнерів
                    docker.withRegistry('') {
                        def mariadb = docker.image('kuzma343/mariadb:10.5').run('-d -p 3306:3306')
                        def zabbixAgent = docker.image('kuzma343/zabbix-agent:alpine-6.2-latest').run('-d')
                        def zabbixServer = docker.image('kuzma343/zabbix-server-mysql:alpine-6.2-latest').run('-d')
                        def zabbixWeb = docker.image('kuzma343/zabbix-web-nginx-mysql:alpine-6.2-latest').run('-d -p 8080:8787')
                        
                        // Отримання ID контейнерів
                        def mariadbContainerId = mariadb.id
                        def zabbixAgentContainerId = zabbixAgent.id
                        def zabbixServerContainerId = zabbixServer.id
                        def zabbixWebContainerId = zabbixWeb.id
                        
                        // Збереження ID контейнерів для використання у наступних етапах
                        env.MARIADB_CONTAINER_ID = mariadbContainerId
                        env.ZABBIX_AGENT_CONTAINER_ID = zabbixAgentContainerId
                        env.ZABBIX_SERVER_CONTAINER_ID = zabbixServerContainerId
                        env.ZABBIX_WEB_CONTAINER_ID = zabbixWebContainerId
                    }
                }
            }
        }
        
      
        
        stage('Cleanup') {
            steps {
                script {
                    // Зупинка та видалення контейнерів
                    docker.withRegistry('') {
                        docker.container(env.MARIADB_CONTAINER_ID).stop()
                        docker.container(env.ZABBIX_AGENT_CONTAINER_ID).stop()
                        docker.container(env.ZABBIX_SERVER_CONTAINER_ID).stop()
                        docker.container(env.ZABBIX_WEB_CONTAINER_ID).stop()
                        
                        docker.container(env.MARIADB_CONTAINER_ID).remove(force: true)
                        docker.container(env.ZABBIX_AGENT_CONTAINER_ID).remove(force: true)
                        docker.container(env.ZABBIX_SERVER_CONTAINER_ID).remove(force: true)
                        docker.container(env.ZABBIX_WEB_CONTAINER_ID).remove(force: true)
                    }
                }
            }
        }
    }
}

