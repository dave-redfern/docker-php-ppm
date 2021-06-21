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
RUN curl --silent --fail --location --retry 3 --output /tmp/ppm.phar --url https://github.com/somnambulist-tech/phppm-phar/releases/download/6.1.0/ppm.phar \
  && php -r " \
  \$signature = '02fc62b045e6cc2f04af5655878b674a909752da92ab402606c52871b70bbe6278ded673dbdc1c8c2d9130d65db9431c'; \
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
