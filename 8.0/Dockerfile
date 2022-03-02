#
# Dockerfile for a minimal PHP-PPM run time
#

FROM somnambulist/php-base:8.0-latest

# use php8 for php 8.X packages
RUN apk --update add ca-certificates \
    && apk update \
    && apk upgrade \
    && apk --no-cache add -U \
    # Packages
    php8-cgi \
    php8-pcntl \
    php8-posix \
    php8-shmop \
    php8-sysvshm \
    php8-sysvshm \
    php8-sysvshm \
    # Clean up
    && rm -rf /var/cache/apk/* /tmp/*

# setup php-pm -- shamelessly borrowed from the above composer code :)
RUN curl --silent --fail --location --retry 3 --output /tmp/ppm.phar --url https://github.com/somnambulist-tech/phppm-phar/releases/download/7.0.2/ppm.phar \
  && php -r " \
  \$signature = '8582bc69e9f923906172bd369af3b72789857db636d09cbec1707dc700caa68e6f205af43776aa2d5cc0b3321e5fe6d0'; \
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
