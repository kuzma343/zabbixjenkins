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

       stages {
    stage("Build and Push Images") {
        steps {
            echo 'Building and pushing zabbix-agent image ...'
            sh 'docker build -t kuzma343/zabbix-agent:alpine-6.2-latest .'
            sh 'docker push kuzma343/zabbix-agent:alpine-6.2-latest'

            echo 'Building and pushing mariadb image ...'
            sh 'docker build -t kuzma343/mariadb:10.5 .'
            sh 'docker push kuzma343/mariadb:10.5'

            echo 'Building and pushing zabbix-server image ...'
            sh 'docker build -t kuzma343/zabbix-server-mysql:alpine-6.2-latest .'
            sh 'docker push kuzma343/zabbix-server-mysql:alpine-6.2-latest'

            echo 'Building and pushing zabbix-web image ...'
            sh 'docker build -t kuzma343/zabbix-web-nginx-mysql:alpine-6.2-latest .'
            sh 'docker push kuzma343/zabbix-web-nginx-mysql:alpine-6.2-latest'
        }
    }

    stage("Run Services") {
        steps {
            echo 'Running zabbix-agent service ...'
            sh 'docker run -d --name zabbix-agent -p 161:161/udp kuzma343/zabbix-agent:alpine-6.2-latest'

            echo 'Running mariadb service ...'
            sh 'docker run -d --name mariadb -e MYSQL_ROOT_PASSWORD=your_root_password -e MYSQL_USER=your_user -e MYSQL_PASSWORD=your_password -e MYSQL_DATABASE=your_database_name -p 3306:3306 kuzma343/mariadb:10.5'

            echo 'Running zabbix-server service ...'
            sh 'docker run -d --name zabbix-server -e DB_SERVER_HOST=mariadb -e MYSQL_USER=your_user -e MYSQL_PASSWORD=your_password -e MYSQL_DATABASE=your_database_name -p 10051:10051 kuzma343/zabbix-server-mysql:alpine-6.2-latest'

            echo 'Running zabbix-web service ...'
            sh 'docker run -d --name zabbix-web -e DB_SERVER_HOST=mariadb -e MYSQL_USER=your_user -e MYSQL_PASSWORD=your_password -e MYSQL_DATABASE=your_database_name -e ZBX_SERVER_HOST=zabbix-server -p 8787:8080 -p 443:443 kuzma343/zabbix-web-nginx-mysql:alpine-6.2-latest'
        }
    }
}

    }


