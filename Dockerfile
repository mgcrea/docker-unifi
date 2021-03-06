FROM ubuntu:16.04
MAINTAINER Olivier Louvignes <olivier@mgcrea.io>

ARG IMAGE_VERSION
ENV IMAGE_VERSION ${IMAGE_VERSION:-1.0.0}
ENV UNIFI_USER unifi
ENV UNIFI_GROUP unifi
ENV UNIFI_WORKDIR /usr/lib/unifi
ENV UID 106
ENV GID 107

RUN apt-get update \
  && apt-get upgrade -y --no-install-recommends \
  && apt-get install apt-transport-https binutils curl ca-certificates jsvc psmisc sudo lsb-release tzdata -y --no-install-recommends

# Install mongo 3.4
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv BC711F9BA15703C6

RUN apt-get update \
  #   && apt-get install oracle-java8-installer -y --no-install-recommends \
  && apt-get install openjdk-8-jre-headless -y --no-install-recommends \
  && apt-get install mongodb-org -y --no-install-recommends \
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
