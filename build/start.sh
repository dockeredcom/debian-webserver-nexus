#!/bin/bash

###
#
# Yves Vindevogel
# 2018-09-09
# Version 1.0.0
#
# This script is when the server starts. It starts cron, gets the sources from Nexus and unzips them for Nginx.
# Finally, it launches the webserver.
#
###

# Making sure that cron is started because we need this for the refresh.sh script.

service cron start

# Make sure JAVA_HOME is exported (remember, we are not logged in!).

source /etc/profile.d/java.sh

# The sdkman-init script is added in the .bashrc file during installation.
# Without calling that file, jbake is not on the path.
# Which is not dramatic, but then you must hard-code the full path.

source /root/.bashrc

# Running the gradle command to download the website.

gradle -b /srv/gradle/build.gradle --refresh-dependencies


# We are running and halting the nginx command here.
# This prevents the script to stop, which is what we need.
# A docker container is running as long as a command is running (hence often using docker run /bin/bash).
# See: https://stackoverflow.com/questions/18861300/how-to-run-nginx-within-a-docker-container-without-halting

/usr/sbin/nginx
