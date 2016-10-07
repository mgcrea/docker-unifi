# mgcrea/unifi [![Docker Pulls](https://img.shields.io/docker/pulls/mgcrea/unifi.svg)](https://registry.hub.docker.com/u/mgcrea/unifi/)  [![Docker Latest](https://img.shields.io/badge/latest-v5.2.9-blue.svg)](https://hub.docker.com/r/mgcrea/unifi/tags/)

Docker image for Ubiquiti [Unifi Controller](https://www.ubnt.com/enterprise/software/)


## Install

```sh
docker pull mgcrea/unifi:5
```


## Quickstart

Use [docker-compose](https://docs.docker.com/compose/) to start the service

```sh
docker-compose up -d
```


### Compose

```yaml
version: '2'
services:
  unifi_controller:
    image: mgcrea/unifi:5
    container_name: unifi_controller
    environment:
      - TZ=Europe/Paris
    network_mode: "bridge"
    privileged: true
    volumes:
      - ./data/lib:/var/lib/unifi
      - ./data/log:/var/log/unifi
      - ./data/work:/usr/lib/unifi/work
    ports:
      - "8080:8080/tcp"
      - "8443:8443/tcp"
      - "8880:8880/tcp"
      - "8843:8843/tcp"
      - "3478:3478/udp"
    restart: always
```


## Debug

Create and inspect a new instance

```sh
docker-compose run unifi_controller /bin/bash
```

Inspect a running instance

```sh
docker exec -it unifi_controller script -q -c "TERM=xterm /bin/bash" /dev/null;
```
