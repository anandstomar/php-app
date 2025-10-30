# Use official PHP + Apache base image
FROM php:8.1-apache

# Avoid interactive prompts and speed up apt operations
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Install only what's needed and remove apt lists to keep image small.
# Use --no-install-recommends and combine into a single RUN layer.
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      libpq-dev \
      build-essential \
      pkg-config \
      libssl-dev; \
    docker-php-ext-install pdo_pgsql; \
    apt-get purge -y --auto-remove build-essential pkg-config libssl-dev; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy application files into web root and set proper ownership
COPY --chown=www-data:www-data . /var/www/html

EXPOSE 80

# Optional: simple healthcheck (container must respond on /)
HEALTHCHECK --interval=15s --timeout=3s --start-period=10s --retries=3 \
  CMD curl -f http://localhost/ || exit 1











# # Dockerfile
# FROM php:8.1-apache

# # RUN apt-get update \
# #   && apt-get install -y --no-install-recommends libpq-dev ca-certificates \
# #   && docker-php-ext-install pdo_pgsql \
# #   && apt-get purge -y --auto-remove libpq-dev \
# #   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# RUN apt-get update \
#   && apt-get install -y --no-install-recommends libpq-dev ca-certificates \
#   && docker-php-ext-install pdo_pgsql \
#   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# COPY --chown=www-data:www-data . /var/www/html

# EXPOSE 80

