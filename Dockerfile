FROM ubuntu:16.04
MAINTAINER Olivier Louvignes <olivier@mgcrea.io>

ARG IMAGE_VERSION
ENV IMAGE_VERSION ${IMAGE_VERSION:-1.0.0}
ENV UNIFI_USER unifi
ENV UNIFI_GROUP unifi
ENV UNIFI_WORKDIR /usr/lib/unifi
ENV UID 106
ENV GID 107

# Install mongo
RUN echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.4.list \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6

RUN apt-get update \
  && apt-get upgrade -y --no-install-recommends \
  && apt-get install binutils curl ca-certificates mongodb-org openjdk-8-jre-headless jsvc psmisc sudo lsb-release -y --no-install-recommends \
  && apt-get autoremove -y \
  && apt-get clean

RUN curl -L -o unifi_sysvinit_all.deb http://dl.ubnt.com/unifi/${IMAGE_VERSION}/unifi_sysvinit_all.deb \
  && dpkg -i unifi_sysvinit_all.deb

# Add missing user after install
# RUN groupadd $UNIFI_GROUP --gid $GID \
#   && useradd $UNIFI_USER --uid $UID --gid $GID --home $UNIFI_WORKDIR --shell /bin/sh

# Relink to standard locations
# RUN mkdir /var/lib/unifi && ln -s /var/lib/unifi /usr/lib/unifi/data \
#  && mkdir /var/log/unifi && ln -s /var/log/unifi /usr/lib/unifi/logs \
#  && mkdir /var/run/unifi && ln -s /var/run/unifi /usr/lib/unifi/run

VOLUME ["/var/lib/unifi", "/var/log/unifi", "/var/run/unifi", "/usr/lib/unifi/work"]

EXPOSE 8080/tcp 8880/tcp 8843/tcp 8443/tcp 3478/udp

WORKDIR $UNIFI_WORKDIR

RUN mkdir -p /usr/lib/unifi/data && \
    touch /usr/lib/unifi/data/.unifidatadir

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

ADD ./files/entrypoint.sh /sbin/entrypoint.sh
RUN chmod 770 /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]
