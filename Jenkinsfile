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
        stage('Build and Deploy') {
            steps {
                script {
                    // Запуск контейнерів забікса
                    docker.image('kuzma343/zabbix-agent:alpine-6.2-latest').run("-p 161:161/udp -p 10050:10050", 'zabbix-agent')
                    docker.image('kuzma343/mariadb:10.5').withRun("-e MYSQL_ROOT_PASSWORD=your_root_password -e MYSQL_USER=your_user -e MYSQL_PASSWORD=your_password -e MYSQL_DATABASE=your_database_name -p 3306:3306", 'mariadb')
                    docker.image('kuzma343/zabbix-server-mysql:alpine-6.2-latest').withRun("-e DB_SERVER_HOST=mariadb -e MYSQL_USER=your_user -e MYSQL_PASSWORD=your_password -e MYSQL_DATABASE=your_database_name -p 10051:10051", 'zabbix-server')
                    docker.image('kuzma343/zabbix-web-nginx-mysql:alpine-6.2-latest').withRun("-e DB_SERVER_HOST=mariadb -e MYSQL_USER=your_user -e MYSQL_PASSWORD=your_password -e MYSQL_DATABASE=your_database_name -e ZBX_SERVER_HOST=zabbix-server -p 8787:8080 -p 443:443", 'zabbix-web')
                }
            }
        }
    }

    post {
        always {
            script {
                // Зупинка контейнерів після виконання
                docker.image('kuzma343/zabbix-agent:alpine-6.2-latest').stop()
                docker.image('kuzma343/mariadb:10.5').stop()
                docker.image('kuzma343/zabbix-server-mysql:alpine-6.2-latest').stop()
                docker.image('kuzma343/zabbix-web-nginx-mysql:alpine-6.2-latest').stop()
            }
        }
    }
}


}

