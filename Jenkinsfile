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
    stage("Build and Push Images") {
        steps {
            script {
                def zabbixAgentImage = "kuzma343/zabbix-agent:alpine-6.2-latest"
                def mariadbImage = "kuzma343/mariadb:10.5"
                def zabbixServerImage = "kuzma343/zabbix-server-mysql:alpine-6.2-latest"
                def zabbixWebImage = "kuzma343/zabbix-web-nginx-mysql:alpine-6.2-latest"

                // Build and push Zabbix Agent image
                echo "Building and pushing Zabbix Agent image ..."
                sh "docker build -t ${zabbixAgentImage} zabbix-agent/"
                sh "docker push ${zabbixAgentImage}"

                // Build and push MariaDB image
                echo "Building and pushing MariaDB image ..."
                sh "docker build -t ${mariadbImage} mariadb/"
                sh "docker push ${mariadbImage}"

                // Build and push Zabbix Server image
                echo "Building and pushing Zabbix Server image ..."
                sh "docker build -t ${zabbixServerImage} zabbix-server/"
                sh "docker push ${zabbixServerImage}"

                // Build and push Zabbix Web image
                echo "Building and pushing Zabbix Web image ..."
                sh "docker build -t ${zabbixWebImage} zabbix-web/"
                sh "docker push ${zabbixWebImage}"
            }
        }
    }

    stage("Deploy Services") {
        steps {
            echo 'Running zabbix-agent service ...'
            sh "docker run -d --name zabbix-agent -p 161:161/udp kuzma343/zabbix-agent:alpine-6.2-latest"

            echo 'Running mariadb service ...'
            sh "docker run -d --name mariadb -e MYSQL_ROOT_PASSWORD=your_root_password -e MYSQL_USER=your_user -e MYSQL_PASSWORD=your_password -e MYSQL_DATABASE=your_database_name -p 3306:3306 kuzma343/mariadb:10.5"

            echo 'Running zabbix-server service ...'
            sh "docker run -d --name zabbix-server -e DB_SERVER_HOST=mariadb -e MYSQL_USER=your_user -e MYSQL_PASSWORD=your_password -e MYSQL_DATABASE=your_database_name -p 10051:10051 kuzma343/zabbix-server-mysql:alpine-6.2-latest"

            echo 'Running zabbix-web service ...'
            sh "docker run -d --name zabbix-web -e DB_SERVER_HOST=mariadb -e MYSQL_USER=your_user -e MYSQL_PASSWORD=your_password -e MYSQL_DATABASE=your_database_name -e ZBX_SERVER_HOST=zabbix-server -p 8787:8080 -p 443:443 kuzma343/zabbix-web-nginx-mysql:alpine-6.2-latest"
        }
    }
}

}

