FROM php:8.1-apache

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      libpq-dev \
      libpq5 \
      build-essential \
      pkg-config \
      gnupg \
      curl \
      libssl-dev \
    ; \
    docker-php-ext-install pdo_pgsql; \
    apt-get purge -y --auto-remove build-essential pkg-config libssl-dev curl gnupg; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --chown=www-data:www-data . /var/www/html

EXPOSE 80

HEALTHCHECK --interval=15s --timeout=3s --start-period=10s --retries=3 \
  CMD curl -f http://localhost/ || exit 1
