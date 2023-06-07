pipeline {
    agent any

    stages {
        stage('Build and Push Zabbix Agent') {
            steps {
                script {
                    docker.image('kuzma343/zabbix-agent:alpine-6.2-latest').pull()
                    docker.image('kuzma343/zabbix-agent:alpine-6.2-latest').push('kuzma343/zabbixrepo')
                }
            }
        }

        stage('Build and Push MariaDB') {
            steps {
                script {
                    docker.image('kuzma343/mariadb:10.5').pull()
                    docker.image('kuzma343/mariadb:10.5').push('kuzma343/zabbixrepo')
                }
            }
        }

        stage('Build and Push Zabbix Server') {
            steps {
                script {
                    docker.image('kuzma343/zabbix-server-mysql:alpine-6.2-latest').pull()
                    docker.image('kuzma343/zabbix-server-mysql:alpine-6.2-latest').push('kuzma343/zabbixrepo')
                }
            }
        }

        stage('Build and Push Zabbix Web Nginx') {
            steps {
                script {
                    docker.image('kuzma343/zabbix-web-nginx-mysql:alpine-6.2-latest').pull()
                    docker.image('kuzma343/zabbix-web-nginx-mysql:alpine-6.2-latest').push('kuzma343/zabbixrepo')
                }
            }
        }
    }
}
