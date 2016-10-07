# mgcrea/unifi [![Docker Pulls](https://img.shields.io/docker/pulls/mgcrea/unifi.svg)](https://registry.hub.docker.com/u/mgcrea/unifi/)

Docker image for [Unifi Controller](https://www.ubnt.com/enterprise/software/)

## Install

```sh
docker pull mgcrea/unifi:5
```

## Quickstart

Use [docker-compose] to start the service

```sh
# Start the service
docker-compose up -d
```

### Compose

```yaml
version: '2'
services:
  unifi:
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
    restart: always
```

## Debug

Inspect a running instance

```sh
docker run --privileged --rm -it mgcrea/unifi-video /bin/bash
```

Inspect a new instance

```sh
docker-compose run unifi /bin/bash
```
