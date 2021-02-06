#
# Dockerfile for a minimal PHP-PPM run time
#

FROM somnambulist/php-base:7.4-latest

# use php7 for php 7.X packages
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
RUN curl --silent --fail --location --retry 3 --output /tmp/ppm.phar --url https://github.com/somnambulist-tech/phppm-phar/releases/download/6.0.0/ppm.phar \
  && php -r " \
  \$signature = 'd2abb2629e1e360755b85faf8079990d59ff0aef00d1b67d3d27d6c54b6f23e0eb1579874d4fb41113fe252df02dd237'; \
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
