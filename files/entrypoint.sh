#!/bin/bash
# strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# allow user override on docker start
if [[ $UID != "106" ]]; then
  echo "Setting up user..."
  usermod -u $UID $UNIFI_USER
fi
if [[ $GID != "107" ]]; then
  echo "Setting up group..."
  usermod -g $GID $UNIFI_GROUP
fi

# set permissions so that we have access to volumes
DOCKER_CHOWN_VOLUMES=${DOCKER_CHOWN_VOLUMES:-"no"}
if [[ $DOCKER_CHOWN_VOLUMES == "yes" ]]; then
  echo "Setting up permissions..."
  chown -R $UNIFI_USER:$UNIFI_GROUP /var/lib/unifi /var/log/unifi /usr/lib/unifi/work
fi

echo "Starting unifi..."
/usr/bin/jsvc -cwd $UNIFI_WORKDIR -nodetach -user root -home /usr/lib/jvm/java-8-openjdk-amd64 -cp /usr/share/java/commons-daemon.jar:/usr/lib/unifi/lib/ace.jar -pidfile /var/run/unifi/unifi.pid -procname unifi -outfile SYSLOG -errfile SYSLOG -Dunifi.datadir=/var/lib/unifi -Dunifi.logdir=/var/log/unifi -Dunifi.rundir=/var/run/unifi -Xmx1024M -Djava.awt.headless=true -Dfile.encoding=UTF-8 com.ubnt.ace.Launcher start