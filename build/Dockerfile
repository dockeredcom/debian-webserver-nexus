FROM dockeredcom/debian-oraclejdk:latest

MAINTAINER Yves Vindevogel (yves.vindevogel@asynchrone.com / yves.vindevogel@dockered.com)

ARG DEBIAN_FRONTEND=noninteractive

ENV NEXUS_URL=https://nexus.server/repository/releases
ENV NEXUS_GROUP=websites
ENV NEXUS_ARTIFACT=website
ENV NEXUS_VERSION=1.0.0
ENV NEXUS_INTERVAL="*/15 * * * *"
ENV NEXUS_USER=nexus
ENV NEXUS_PASSWORD=password
ENV SHELL=/bin/bash

WORKDIR /srv

COPY ./nginx.list   /etc/apt/sources.list.d/nginx.list
COPY ./nginx.conf   /tmp/nginx.conf
COPY ./build.gradle /srv/gradle/build.gradle
COPY ./nexus.crt /srv/crt/nexus.crt
COPY ./start.sh /srv/scripts/start.sh
COPY ./refresh.sh /srv/scripts/refresh.sh

RUN set -x && \ 
    chmod +x /srv/scripts/*.sh && \ 
    /bin/bash -l -c "keytool -import -alias nexus -keystore /opt/oracle-jdk/jre/lib/security/cacerts -storepass changeit -noprompt -file /srv/crt/nexus.crt" && \ 
    /bin/bash -l -c "sdk install gradle" && \ 
    apt-get update --yes && \ 
    apt-get upgrade --yes && \ 
    apt-get install dialog --yes --no-install-recommends && \ 
    apt-get install nginx --yes --no-install-recommends && \ 
    rm -f /etc/nginx/conf.d/default.conf && \ 
    rm -f /etc/nginx/nginx.conf && \ 
    mv /tmp/nginx.conf /etc/nginx/ && \ 
    apt-get install cron --yes --no-install-recommends && \ 
    echo "$NEXUS_INTERVAL root /srv/scripts/refresh.sh" > /etc/cron.d/nexus && \ 
    apt-get autoremove --yes && \ 
    apt-get clean && \ 
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80

ENTRYPOINT ["/srv/scripts/start.sh"]

CMD ["/bin/bash"]
