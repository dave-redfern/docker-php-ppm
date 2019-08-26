# PHP-FPM Docker Image

Extends the PHP base image to provide a container with PHP-PM as a phar archive.

### Tags

This project is tagged for PHP 7.2 (7.2.X) and PHP 7.3.X. PHP 7.3 uses Alpine 3.10.

Note:

 * only sqlite has been loaded, add MySQL / Postgres if you need them
 
In addition the follow are available:

 * bash
 * curl
 * tini
 * unzip
 * wget

Note:

If you need to install from custom git repos, be sure to setup git.
 
## Intended Usage

Import from this image and add additional setup steps to build your app. For example for PHP 7.3:

```dockerfile
FROM somnambulist/php-ppm:7.3-latest

RUN apk --update add ca-certificates \
    && apk update \
    && apk upgrade \
    && apk --no-cache add -U \
    php7-pdo-pgsql \
    && rm -rf /var/cache/apk/* /tmp/*

```

Note: the minor version does not track the PHP version; it is the revision of the Dockerfile.

A `.dockerignore` should be setup to prevent copying in git and vendor files:

```
.idea
*.md
.git
.dockerignore
node_modules
vendor
var
docker-compose*
```
