### Stage 1: Build zabbix-agent image ###
FROM kuzma343/zabbix-agent:alpine-6.2-latest as zabbix-agent

### Stage 2: Build mariadb image ###
FROM kuzma343/mariadb:10.5 as mariadb

### Stage 3: Build zabbix-server image ###
FROM kuzma343/zabbix-server-mysql:alpine-6.2-latest as zabbix-server

### Stage 4: Build zabbix-web image ###
FROM kuzma343/zabbix-web-nginx-mysql:alpine-6.2-latest as zabbix-web

### Final Stage: Combine all services ###
FROM alpine:latest

# Install Docker CLI for running other containers
RUN apk --no-cache add docker-cli

# Copy zabbix-agent image
COPY --from=zabbix-agent /path/to/zabbix-agent /path/to/zabbix-agent

# Copy mariadb image
COPY --from=mariadb /path/to/mariadb /path/to/mariadb

# Copy zabbix-server image
COPY --from=zabbix-server /path/to/zabbix-server /path/to/zabbix-server

# Copy zabbix-web image
COPY --from=zabbix-web /path/to/zabbix-web /path/to/zabbix-web

# Add necessary configurations and scripts

# Start zabbix-agent service
RUN docker run -d --name zabbix-agent -p 161:161/udp /path/to/zabbix-agent

# Start mariadb service
RUN docker run -d --name mariadb -e MYSQL_ROOT_PASSWORD=your_root_password -e MYSQL_USER=your_user -e MYSQL_PASSWORD=your_password -e MYSQL_DATABASE=your_database_name -p 3306:3306 /path/to/mariadb

# Start zabbix-server service
RUN docker run -d --name zabbix-server -e DB_SERVER_HOST=mariadb -e MYSQL_USER=your_user -e MYSQL_PASSWORD=your_password -e MYSQL_DATABASE=your_database_name -p 10051:10051 /path/to/zabbix-server

# Start zabbix-web service
RUN docker run -d --name zabbix-web -e DB_SERVER_HOST=mariadb -e MYSQL_USER=your_user -e MYSQL_PASSWORD=your_password -e MYSQL_DATABASE=your_database_name -e ZBX_SERVER_HOST=zabbix-server -p 8787:8080 -p 443:443 /path/to/zabbix-web
