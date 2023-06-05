pipeline {
    agent any

    stages {
        stage('Build and Run Containers') {
            steps {
                script {
                    // Запуск контейнера mariadb
                    docker.image('kuzma343/mariadb:10.5').run('-d -p 3306:3306 --name mariadb -e MYSQL_ROOT_PASSWORD=your_root_password -e MYSQL_USER=your_user -e MYSQL_PASSWORD=your_password -e MYSQL_DATABASE=your_database_name')

                    // Запуск контейнера zabbix-agent
                    docker.image('kuzma343/zabbix-agent:alpine-6.2-latest').run('-d --link mariadb:mysql --name zabbix-agent')

                    // Запуск контейнера zabbix-server-mysql
                    docker.image('kuzma343/zabbix-server-mysql:alpine-6.2-latest').run('-d --link mariadb:mysql --name zabbix-server-mysql -e DB_SERVER_HOST=mariadb -e MYSQL_USER=your_user -e MYSQL_PASSWORD=your_password -e MYSQL_DATABASE=your_database_name -p 10051:10051')

                    // Запуск контейнера zabbix-web-nginx-mysql
                    docker.image('kuzma343/zabbix-web-nginx-mysql:alpine-6.2-latest').run('-d --link zabbix-server-mysql:zabbix-server-mysql --name zabbix-web-nginx-mysql -e DB_SERVER_HOST=mariadb -e MYSQL_USER=your_user -e MYSQL_PASSWORD=your_password -e MYSQL_DATABASE=your_database_name -e ZBX_SERVER_HOST=zabbix-server -p 8787:8080 -p 443:443')
                }
            }
        }
    }

    post {
        always {
            // Видалення контейнерів після завершення
            script {
                docker.image('kuzma343/mariadb:10.5').stop()
                docker.image('kuzma343/mariadb:10.5').remove()

                docker.image('kuzma343/zabbix-agent:alpine-6.2-latest').stop()
                docker.image('kuzma343/zabbix-agent:alpine-6.2-latest').remove()

                docker.image('kuzma343/zabbix-server-mysql:alpine-6.2-latest').stop()
                docker.image('kuzma343/zabbix-server-mysql:alpine-6.2-latest').remove()

                docker.image('kuzma343/zabbix-web-nginx-mysql:alpine-6.2-latest').stop()
                docker.image('kuzma343/zabbix-web-nginx-mysql:alpine-6.2-latest').remove()
            }
        }
    }
}
