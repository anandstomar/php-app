FROM php:8.1-apache

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Install dependencies required to build pdo_pgsql and keep runtime libpq
RUN set -eux; \
    apt-get update; \
    # install runtime + build deps
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
    # build and enable pdo_pgsql
    docker-php-ext-install pdo_pgsql; \
    # remove compile-time packages but KEEP libpq5 (runtime)
    apt-get purge -y --auto-remove build-essential pkg-config libssl-dev curl gnupg; \
    # cleanup apt lists
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy application files into web root and set proper ownership
COPY --chown=www-data:www-data . /var/www/html

EXPOSE 80

HEALTHCHECK --interval=15s --timeout=3s --start-period=10s --retries=3 \
  CMD curl -f http://localhost/ || exit 1
