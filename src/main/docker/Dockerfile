###
#
# Yves Vindevogel
# 2018-09-09
# Version 1.0.0
#
###

FROM dockeredcom/debian-oraclejdk:latest

MAINTAINER Yves Vindevogel (yves.vindevogel@asynchrone.com / yves.vindevogel@dockered.com)

ARG DEBIAN_FRONTEND=noninteractive

# All environment variables needed in scripts.
# Each one of these variable should be set using either an environment file or using environment variables.
# The variables are used in build.gradle to download the sources from Nexus.

ENV NEXUS_URL=https://nexus.server/repository/releases
ENV NEXUS_GROUP=websites
ENV NEXUS_ARTIFACT=website
ENV NEXUS_VERSION=1.0.0
ENV NEXUS_INTERVAL="*/15 * * * *"
ENV NEXUS_USER=nexus
ENV NEXUS_PASSWORD=password

# Standard shell variable as found everywhere.

ENV SHELL=/bin/bash

# All files go into /srv. It's nice when we open a shell that we are straight in /srv.

WORKDIR /srv

# Yves Vindevogel
# 2018-09-09
# By default, Debian installs version 1.10.3, whereas Nginx itselfs indicates that they are at 1.14.0 (stable releases).
# Therefore, using the packages provided by Nginx instead of the ones coming with Debian.

COPY ./nginx.list   /etc/apt/sources.list.d/nginx.list

# Copying the nginx config file. One major update in that file is that nginx is not running as daemon.
# Nginx is not running as daemon, because we use it to keep the container running when calling start.sh.

COPY ./nginx.conf   /tmp/nginx.conf

# Copy the build.gradle file. This file contains all the information needed to download and unzip the website into /srv/nginx.

COPY ./build.gradle /srv/gradle/build.gradle

# Copy the certificate of the server in /tmp so we can import it later.

COPY ./nexus.crt /srv/crt/nexus.crt

# Copy the start.sh and refresh.sh file, used to download the sources and start the nginx server.

COPY ./start.sh /srv/scripts/start.sh
COPY ./refresh.sh /srv/scripts/refresh.sh

# From here on, only RUN !

# Making sure the scripts are executable.

RUN chmod +x /srv/scripts/*.sh

# Installation of the certificate. We need this later to be able to pull from nexus.asynchrone.net.

RUN /bin/bash -l -c "keytool -import -alias nexus -keystore /opt/oracle-jdk/jre/lib/security/cacerts -storepass changeit -noprompt -file /srv/crt/nexus.crt"

# Installation of Gradle using SDKMAN.

RUN /bin/bash -l -c "sdk install gradle"

# Installation of packages.

RUN apt-get update --yes
RUN apt-get upgrade --yes

# Supporting packages.

RUN apt-get install dialog --yes --no-install-recommends

# Installing nginx main package (version 1.14.0).

RUN apt-get install nginx --yes --no-install-recommends

# Removing the default.conf, it's no longer needed, nor even included in the nginx.conf.
# Moving our own config file in.

RUN rm -f /etc/nginx/conf.d/default.conf
RUN rm -f /etc/nginx/nginx.conf
RUN mv /tmp/nginx.conf /etc/nginx/

# Installing cron so that the refresh.sh script can be called.

RUN apt-get install cron --yes --no-install-recommends

# Adding a cron job to refresh the site.

RUN echo "$NEXUS_INTERVAL root /srv/scripts/refresh.sh" > /etc/cron.d/nexus

# Default cleanup.

RUN apt-get autoremove --yes
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Default port for http.

EXPOSE 80

# Running the start script that starts nginx (not as a daemon!).
# Basically, you don't need the /bin/bash to keep the container running.
# Nginx is running and keeping the container alive.

ENTRYPOINT ["/srv/scripts/start.sh"]

CMD ["/bin/bash"]
