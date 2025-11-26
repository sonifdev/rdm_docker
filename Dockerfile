FROM php:7.2-apache

# Fix Debian Buster repo 404
RUN sed -i 's|deb.debian.org|archive.debian.org|g' /etc/apt/sources.list && \
  sed -i 's|security.debian.org|archive.debian.org|g' /etc/apt/sources.list && \
  echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid && \
  apt-get update && \
  apt-get install -y \
      libpng-dev \
      libjpeg-dev \
      libfreetype6-dev \
      libzip-dev \
      libicu-dev \
      zip curl unzip wget && \
  rm -rf /var/lib/apt/lists/*

# ================================
# Install core PHP extensions
# ================================

# GD with JPEG + Freetype
RUN docker-php-ext-configure gd \
      --with-freetype-dir=/usr/include/ \
      --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd

RUN docker-php-ext-install \
      mysqli \
      pdo \
      pdo_mysql \
      mbstring \
      intl \
      zip

# Copy your app
COPY ioncube.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/
COPY RDMhosting/ /var/www/html/

WORKDIR /var/www/html

# Apache mod_rewrite
RUN a2enmod rewrite

# Permissions
RUN chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && find /var/www/html -type f -exec chmod 644 {} \;

# Enable AllowOverride All
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

# Enable ionCube
RUN echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20170718/ioncube.so" \
    > /usr/local/etc/php/conf.d/00-ioncube.ini

# allow_url_fopen
RUN echo "allow_url_fopen=On" > /usr/local/etc/php/conf.d/allow_url_fopen.ini

EXPOSE 80
