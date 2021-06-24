version: '2'

networks:
  default-network:
    external:
      name: ${PROJECT_GROUP_NAME}_default-network

services:
  web-server:
    volumes:
      - ../source:/var/www/html
      - ./etc/drush:/var/www/html/drush
    ports:
      - "80:80"

  nginx:
    extends:
      file: docker-compose.common.yml
      service: nginx
    ports:
      - "443:443"

  database:
    extends:
      file: docker-compose.common.yml
      service: database
    environment:
      - MYSQL_PASSWORD=
      - MYSQL_ROOT_PASSWORD=
    ports:
      - "3306:3306"

  smtp-server:
    extends:
      file: docker-compose.common.yml
      service: smtp-server
    ports:
      - "25:25"
