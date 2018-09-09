#!/bin/bash

###
#
# Yves Vindevogel
# 2018-09-09
# Version 1.0.0
#
# This script is run from cron to update the sources from Nexus.
#
###

# Make sure JAVA_HOME is exported (remember, we are not logged in!).

source /etc/profile.d/java.sh

# The sdkman-init script is added in the .bashrc file during installation.
# Without calling that file, jbake is not on the path.
# Which is not dramatic, but then you must hard-code the full path.

source /root/.bashrc

# This should download new versions if available and set right using e.g. 1.+.

gradle -b /srv/gradle/build.gradle --refresh-dependencies
