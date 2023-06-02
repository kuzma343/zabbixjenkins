#!groovy
//  groovy Jenkinsfile
properties([disableConcurrentBuilds()])

pipeline  {
        agent { 
           label ''
        }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
        timestamps()
    }
    stages {
        
stage("Run docker zabbix-agent") {
steps {
echo 'Running docker container...'
sh '''
docker run -d
--name zabbix-agent
-p 161:161/udp
-p 10050:10050
-p 1099:1099
-p 9999:9999
kuzma343/zabbix-agent:alpine-6.2-latest
'''
}
}
      stage("Create docker zabbix-agent") {
steps {
echo 'Creating docker image ...'
dir('.') {
sh "docker build --no-cache -t kuzma343/website ."
}
}
}

stage("Run mariadb container") {
steps {
sh "docker run -d \
--name mariadb \
-e MYSQL_ROOT_PASSWORD=your_root_password \
-e MYSQL_USER=your_user \
-e MYSQL_PASSWORD=your_password \
-e MYSQL_DATABASE=your_database_name \
-p 3306:3306 \
kuzma343/mariadb:10.5"
}
}
      stage("Create and Run Zabbix Agent Docker Container") {
steps {
echo 'Creating and running Zabbix Agent Docker container...'
dir('.') {
sh "docker run -d
--name zabbix-server
-e DB_SERVER_HOST=mariadb
-e MYSQL_USER=your_user
-e MYSQL_PASSWORD=your_password
-e MYSQL_DATABASE=your_database_name
-p 10051:10051
kuzma343/zabbix-server-mysql:alpine-6.2-latest"
}
}
}
      
stage("Create and run Zabbix web container") {
    steps {
        echo 'Creating and running Zabbix web container...'
        sh '''
            docker run -d \
              --name zabbix-web \
              -e DB_SERVER_HOST=mariadb \
              -e MYSQL_USER=your_user \
              -e MYSQL_PASSWORD=your_password \
              -e MYSQL_DATABASE=your_database_name \
              -e ZBX_SERVER_HOST=zabbix-server \
              -p 8080:8080 \
              -p 443:443 \
              kuzma343/zabbix-web-nginx-mysql:alpine-6.2-latest
        '''
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
                docker stop zabbixrepo
                '''
            }
        } 
        stage("docker remove") {
            steps {
                echo " ============== removing all docker containers =================="
                sh '''
                docker rm  zabbixrepo 
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
