# Dockerfile
FROM php:8.1-apache

# RUN apt-get update \
#   && apt-get install -y --no-install-recommends libpq-dev ca-certificates \
#   && docker-php-ext-install pdo_pgsql \
#   && apt-get purge -y --auto-remove libpq-dev \
#   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt-get update \
  && apt-get install -y --no-install-recommends libpq-dev ca-certificates \
  && docker-php-ext-install pdo_pgsql \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


COPY --chown=www-data:www-data . /var/www/html

EXPOSE 80

