DOCKER_IMAGE := mgcrea/unifi
IMAGE_VERSION := 5.2.7
BASE_IMAGE := ubuntu:14.04

all: build

bash:
	@docker run --privileged --rm --net=host -it ${DOCKER_IMAGE} /bin/bash

build:
	@docker build --build-arg IMAGE_VERSION=${IMAGE_VERSION} --tag=${DOCKER_IMAGE}:latest .

base:
	@docker pull ${BASE_IMAGE}

rebuild: base
	@docker build --build-arg IMAGE_VERSION=${IMAGE_VERSION} --tag=${DOCKER_IMAGE}:latest .

release: rebuild
	@docker build --build-arg IMAGE_VERSION=${IMAGE_VERSION} --tag=${DOCKER_IMAGE}:${IMAGE_VERSION} .
	@scripts/tag.sh ${DOCKER_IMAGE} ${IMAGE_VERSION}

push:
	@scripts/push.sh ${DOCKER_IMAGE} ${IMAGE_VERSION}
