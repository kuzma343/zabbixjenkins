pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                sh 'docker rm -f zabbix-agent'
                sh 'docker run -d --name zabbix-agent -p 161:161/udp -p 10050:10050 -p 1099:1099 -p 9999:9999 kuzma343/zabbix-agent:alpine-6.2-latest'
                sh 'docker rm -f mariadb'
                sh 'docker run -d --name mariadb -e MYSQL_ROOT_PASSWORD=your_root_password -e MYSQL_USER=your_user -e MYSQL_PASSWORD=your_password -e MYSQL_DATABASE=your_database_name -p 3306:3306 kuzma343/mariadb:10.5'
                sh 'docker rm -f zabbix-server'
                sh 'docker run -d --name zabbix-server -e DB_SERVER_HOST=mariadb -e MYSQL_USER=your_user -e MYSQL_PASSWORD=your_password -e MYSQL_DATABASE=your_database_name -p 10051:10051 kuzma343/zabbix-server-mysql:alpine-6.2-latest'
                sh 'docker rm -f zabbix-web'
                sh 'docker run -d --name zabbix-web -e DB_SERVER_HOST=mariadb -e MYSQL_USER=your_user -e MYSQL_PASSWORD=your_password -e MYSQL_DATABASE=your_database_name -e ZBX_SERVER_HOST=zabbix-server -p 8080:8080 -p 443:443 kuzma343/zabbix-web:<your_version>'
            }
        }
    }
}






