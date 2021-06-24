version: '2'

services:
  nginx:
    extends:
      file: docker-compose.common.yml
      service: nginx

  varnish:
    extends:
      file: docker-compose.common.yml
      service: varnish

  web-server:
    extends:
      file: docker-compose.common.yml
      service: web-server

  database:
    extends:
      file: docker-compose.common.yml
      service: database

  memcached:
    extends:
      file: docker-compose.common.yml
      service: memcached

  apache-solr:
    extends:
      file: docker-compose.common.yml
      service: apache-solr

  smtp-server:
    extends:
      file: docker-compose.common.yml
      service: smtp-server

networks:
  default-network: