#
# Dockerfile for a minimal PHP-PPM run time
#

FROM somnambulist/php-base:8.1-latest

# use php81 for php 81.X packages
RUN apk --update add ca-certificates \
    && apk update \
    && apk upgrade \
    && apk --no-cache add -U \
    # Packages
    php81-cgi \
    php81-pcntl \
    php81-posix \
    php81-shmop \
    php81-sysvshm \
    php81-sysvshm \
    php81-sysvshm \
    # Clean up
    && rm -rf /var/cache/apk/* /tmp/*

# setup php-pm -- shamelessly borrowed from the above composer code :)
RUN curl --silent --fail --location --retry 3 --output /tmp/ppm.phar --url https://github.com/somnambulist-tech/phppm-phar/releases/download/7.0.1/ppm.phar \
  && php -r " \
  \$signature = '20e892043c442834596201a3baecd1faed8ee1abe41c540108c00e17e7f99c2fc017534d344ece7972757d6d1783a577'; \
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
