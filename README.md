# Purpose

This image provides a webserver (Nginx) which receives its content via a download from Nexus using a small Gradle project

## 1. Flow

1. The sources are downloaded as a .zip file from Nexus using the criteria specified with the ENV variables.
2. All files are unzipped in /srv/nginx, the root directory for the webserver.
3. Nginx serves this static directory.

## 2. Current versions

- Gradle: 4.1.0
- Nginx: 1.14.0.
- Oracle JDK: 8u181-b13 as provided by the debian-oracle image, needed by Gradle.

## 3. Usage

### 3.1 Environment variables

This image has several environment variables that are used in the scripts to fetch data from the right repository and branch, set the location where the Jbake sources are and set the refresh timing. You can either provide them as separate environments or through an environment file when you run the image.

```
NEXUS_USER=nexus
NEXUS_PASSWORD=password
NEXUS_URL=https://nexus.server/repository/releases
NEXUS_GROUP=websites
NEXUS_ARTIFACT=website
NEXUS_VERSION=1.+
NEXUS_INTERVAL="*/1 * * * *""
```

##### NEXUS_USER

The user used to connect to the Nexus server. The user should have read rights.

##### NEXUS_PASSWORD

The password for the user above.

##### NEXUS_URL

The URL of the Nexus server. You should specify it completely including the repositories.

##### NEXUS_GROUP

The group within the Nexus repository. As example, it's websites here.

##### NEXUS_ARTIFACT

The artifact you want to download. This is the website basically.

##### NEXUS_VERSION

The version of the artifact you want to download.  You can either specify it very strict, like 1.0.0, or more open so it downloads newer versions with 1.+ for example. The Gradle script is called with --refresh-dependencies to make sure it downloads the website if a newer version exists.

##### NEXUS_INTERVAL

The refresh interval for doing a new pull by executing the gradle command. This is a standard cron expression.  The above example refreshes the site every minute, which is most likely what you want for development but not for production.

### 3.2 Running the container

One important note: you must specify all the environment properties as described above.

```
docker run --rm -t -d -p 80:80 --env-file /full-path-to/your-envionment-file.properties --name ws-nexus dockeredcom/debian-webserver-nexus /bin/bash
```

# Support

This image is supported and maintained by Asynchrone.  Asynchrone is the owner of dockered.com (and user dockeredcom). If you have any problems, bugs or questions, please contact info@dockered.com or info@asynchrone.com. Asynchrone will provide the best support possible. However, as this is a free and open source image, Asynchrone cannot guarantee any timing, nor solution. If you want a higher level of support, you may want to consider a paid support option. Contact yves.vindevogel@asynchrone.com for paid support questions.
