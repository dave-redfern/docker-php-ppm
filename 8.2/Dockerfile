#
# Dockerfile for a minimal PHP-PPM run time
#

FROM somnambulist/php-base:8.2-latest

# use php82 for php 82.X packages
RUN apk --update add ca-certificates \
    && apk update \
    && apk upgrade \
    && apk --no-cache add -U \
    # Packages
    php82-cgi \
    php82-pcntl \
    php82-posix \
    php82-shmop \
    php82-sysvshm \
    php82-sysvshm \
    php82-sysvshm \
    # Clean up
    && rm -rf /var/cache/apk/* /tmp/*

# setup php-pm -- shamelessly borrowed from the above composer code :)
RUN curl --silent --fail --location --retry 3 --output /tmp/ppm.phar --url https://github.com/somnambulist-tech/phppm-phar/releases/download/7.2.0/ppm.phar \
  && php -r " \
  \$signature = 'fdcf84d135aa8498d4d7ce72888fde2c4762c937f5f65f4d000b0f9c8268a380da79b47b195605b82b30041ebafdf9e7'; \
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
