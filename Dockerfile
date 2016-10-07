FROM ubuntu:14.04
MAINTAINER Olivier Louvignes <olivier@mgcrea.io>

ARG IMAGE_VERSION
ENV IMAGE_VERSION ${IMAGE_VERSION:-1.0.0}
ENV UNIFI_USER unifi
ENV UNIFI_GROUP unifi
ENV UID 1027
ENV GID 106

# Install mongo
RUN echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org.list \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927

RUN apt-get update \
  && apt-get upgrade -y --no-install-recommends \
  && apt-get install binutils curl ca-certificates mongodb-org openjdk-7-jre-headless jsvc psmisc sudo lsb-release -y --no-install-recommends \
  && apt-get autoremove -y \
  && apt-get clean

RUN curl -L -o unifi_sysvinit_all.deb http://dl.ubnt.com/unifi/${IMAGE_VERSION}/unifi_sysvinit_all.deb \
  && dpkg -i unifi_sysvinit_all.deb

VOLUME ["/var/lib/unifi", "/var/log/unifi", "/var/run/unifi", "/usr/lib/unifi/work"]

EXPOSE 8080/tcp 8443/tcp

WORKDIR /usr/lib/unifi

RUN mkdir -p /usr/lib/unifi/data && \
    touch /usr/lib/unifi/data/.unifidatadir

CMD ["java", "-cp", "/usr/share/java/commons-daemon.jar:/usr/lib/unifi/lib/ace.jar", "-Dav.tempdir=/var/cache/unifi", "-Djava.security.egd=file:/dev/./urandom", "-Xmx1024M", "-Djava.library.path=/usr/lib/unifi/lib", "-Djava.awt.headless=true", "-Dfile.encoding=UTF-8", "com.ubnt.ace.Launcher", "start"]
