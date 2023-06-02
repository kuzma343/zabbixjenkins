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
        stage("Run zabbix-agent") {
            steps {
                echo 'Running zabbix-agent service ...'
                sh "docker run -d --name zabbix-agent -p 161:161/udp kuzma343/zabbix-agent:alpine-6.2-latest"
            }
        }

        stage("Run mariadb") {
            steps {
                echo 'Running mariadb service ...'
                sh "docker run -d --name mariadb -e MYSQL_ROOT_PASSWORD=your_root_password -e MYSQL_USER=your_user -e MYSQL_PASSWORD=your_password -e MYSQL_DATABASE=your_database_name -p 3306:3306 kuzma343/mariadb:10.5"
            }
        }

        stage("Run zabbix-server") {
            steps {
                echo 'Running zabbix-server service ...'
                sh "docker run -d --name zabbix-server -e DB_SERVER_HOST=mariadb -e MYSQL_USER=your_user -e MYSQL_PASSWORD=your_password -e MYSQL_DATABASE=your_database_name -p 10051:10051 kuzma343/zabbix-server-mysql:alpine-6.2-latest"
            }
        }

        stage("Run zabbix-web") {
            steps {
                echo 'Running zabbix-web service ...'
                sh "docker run -d --name zabbix-web -e DB_SERVER_HOST=mariadb -e MYSQL_USER=your_user -e MYSQL_PASSWORD=your_password -e MYSQL_DATABASE=your_database_name -e ZBX_SERVER_HOST=zabbix-server -p 80:80 -p 443:443 kuzma343/zabbix-web-nginx-mysql:alpine-6.2-latest"
            }
        }

        stage("docker login") {
            steps {
                echo " ============== docker login =================="
                withCredentials([usernamePassword(credentialsId: 'DockerHub-Credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh '''
                    docker login -u $USERNAME -p $PASSWORD
                    '''
                }
            }
        }

        stage("docker push") {
            steps {
                echo " ============== pushing image =================="
                sh '''
                docker push kuzma343/zabbixrepo:latest
                '''
            }
        }

        stage("docker stop") {
            steps {
                echo " ============== stopping all images =================="
                sh '''
                docker stop website
                '''
            }
        }

        stage("docker remove") {
            steps {
                echo " ============== removing all docker containers =================="
                sh '''
                docker rm website
                '''
            }
        }

        stage("docker run") {
            steps {
                echo " ============== start server =================="
                sh '''
                docker run -d --restart=always --name website -p 80:80 kuzma343/zabbixrepo
                '''
            }
        }
    }
}

