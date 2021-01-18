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
RUN curl --silent --fail --location --retry 3 --output /tmp/ppm.phar --url https://github.com/somnambulist-tech/phppm-phar/releases/download/5.0.1/ppm.phar \
  && php -r " \
  \$signature = 'fb0779220c3c7206403407909efdfd8d6a82e8985d9601fcb429320ed045de65daf86301b39596e402e1d1fd664c7520'; \
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
