#
# Dockerfile for a minimal PHP-PPM run time
#

FROM somnambulist/php-base:7.4-latest

RUN apk --update add ca-certificates \
    && apk update \
    && apk upgrade \
    && apk --no-cache add -U \
    # Packages
    php7-cgi \
    php7-pcntl \
    php7-posix \
    php7-shmop \
    php7-sysvshm \
    php7-sysvshm \
    php7-sysvshm \
    # Clean up
    && rm -rf /var/cache/apk/* /tmp/*

# setup php-pm -- shamelessly borrowed from the above composer code :)
RUN curl --silent --fail --location --retry 3 --output /tmp/ppm.phar --url https://github.com/somnambulist-tech/phppm-phar/releases/download/5.0.0/ppm.phar \
  && php -r " \
  \$signature = '93a19d7dfb3e22e354e21dc710f4d2426668d498c245c909774ccae9d35c345a3cc7b7e99b08d4e969e243b7d7d2a990'; \
  \$hash = hash_file('sha384', '/tmp/ppm.phar'); \
  if (!hash_equals(\$signature, \$hash)) { \
    unlink('/tmp/ppm.phar'); \
    echo 'Integrity check failed, the ppm.phar archive is either corrupt or worse.' . PHP_EOL; \
    exit(1); \
  }" \
  && mv /tmp/ppm.phar /usr/bin/ppm.phar \
  && ln -s /usr/bin/ppm.phar /usr/bin/ppm \
  && chmod 755 /usr/bin/ppm \
  && ppm --ansi --version --no-interaction
