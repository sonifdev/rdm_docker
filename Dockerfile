FROM php:7.2-apache

# Fix Debian Buster repo 404
RUN sed -i 's|deb.debian.org|archive.debian.org|g' /etc/apt/sources.list && \
  sed -i 's|security.debian.org|archive.debian.org|g' /etc/apt/sources.list && \
  echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid && \
  apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev libzip-dev zip curl unzip wget && \
  rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install mysqli pdo pdo_mysql

# Copy your app
COPY ioncube.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/
COPY RDMhosting/ /var/www/html

# Set working directory
WORKDIR /var/www/html

# Set correct permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Install ionCube Loader
RUN echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20170718/ioncube.so" > /usr/local/etc/php/conf.d/00-ioncube.ini

# Enable allow_url_fopen
RUN echo "allow_url_fopen=On" > /usr/local/etc/php/conf.d/allow_url_fopen.ini

# Enable Apache mod_rewrite (optional but common)
RUN a2enmod rewrite

EXPOSE 80

