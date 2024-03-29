# PHP-PPM Docker Image

Extends the PHP base image to provide a container with PHP-PM as a phar archive.

### Tags

This project is tagged for:

 * PHP 8.1 (8.1.X), Alpine 3.18 (Symfony 6.1+)
 * PHP 8.2 (8.2.X), Alpine 3.18 (Symfony 6.2+)
 * PHP 8.3 (8.3.X), Alpine 3.19 (Symfony 6.4+)

Note:

 * only sqlite has been loaded, add MySQL / Postgres if you need them
 
In addition, the follow are available:

 * bash
 * curl
 * tini
 * unzip
 * wget

Note:

If you need to install from custom git repos, be sure to setup git.
 
## Intended Usage

Import from this image and add additional setup steps to build your app. For example:

```dockerfile
FROM somnambulist/php-ppm:8.3-latest

RUN apk --update add ca-certificates \
    && apk update \
    && apk upgrade \
    && apk --no-cache add -U \
    php83-pdo-pgsql \
    && rm -rf /var/cache/apk/* /tmp/*

# optionally: update composer or add to the above APK line
# RUN composer selfupdate

WORKDIR /app

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 755 /docker-entrypoint.sh
RUN composer selfupdate

COPY composer.* ./
COPY ppm.* ./
COPY .env* ./

RUN composer install --no-suggest --no-scripts --quiet --optimize-autoloader

# copy all the files to the /app folder, use with a .dockerignore
COPY . .

# this should be the same port as defined in the ppm.json file
EXPOSE 8080

# certain settings could be overridden such as the ip / workers
#CMD [ "/docker-entrypoint.sh", "start", "--workers=2", "--cgi-path=/usr/bin/php-cgi7", "--host=0.0.0.0" ]
#CMD [ "/docker-entrypoint.sh", "start", "--workers=2", "--cgi-path=/usr/bin/php-cgi8", "--host=0.0.0.0" ]
CMD [ "/docker-entrypoint.sh", "start" ]
```

Where the `docker-entrypoint.sh` could be something like:

```bash
#!/usr/bin/env bash

set -e
cd /app

cmd="$@"

[[ -d "/app/var" ]] || mkdir -m 0777 "/app/var"
[[ -d "/app/var/cache" ]] || mkdir -m 0777 "/app/var/cache"
[[ -d "/app/var/logs" ]] || mkdir -m 0777 "/app/var/logs"
[[ -d "/app/var/run" ]] || mkdir -m 0777 "/app/var/run"
[[ -d "/app/var/run/ppm" ]] || mkdir -m 0777 "/app/var/run/ppm"
[[ -d "/app/var/tmp" ]] || mkdir -m 0777 "/app/var/tmp"

# run ppm, start should receive arguments from Dockerfile
/usr/bin/ppm $cmd
```

A `.dockerignore` should be setup to prevent copying in git and vendor files:

```
.idea
*.md
.git
.dockerignore
vendor
var
docker-compose*
```

Finally a `ppm.dist.json` should be added to the project that can be copied / modified
to the ppm.json by the docker-entrypoint if needed:

```json
{
    "bridge": "HttpKernel",
    "host": "0.0.0.0",
    "port": 8080,
    "workers": 2,
    "app-env": "docker",
    "debug": 0,
    "logging": 0,
    "bootstrap": "PHPPM\\Bootstraps\\SomnambulistSymfony",
    "max-requests": 500,
    "max-execution-time": 60,
    "populate-server-var": true,
    "socket-path": "var\/run\/ppm\/",
    "pidfile": "var\/run\/ppm\/ppm.pid",
    "cgi-path": "\/usr\/bin\/php-cgi"
}
```

__Note:__ SomnambulistSymfony bootstrap mentioned here is an extension provided by the compiled phar.
It replaces the standard Symfony bootstrap with one that can do kernel detection from a composer.json
file. The standard php-pm Symfony adapter from 2.0.6 can properly resolve .env files.  

__Note:__ while php-pm can be used to serve full-stack applications, it works much better for
APIs that do not have to deal with assets and sessions.
