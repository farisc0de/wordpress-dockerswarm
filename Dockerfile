# This Dockerfile sets up a PHP 8.3 Apache environment for a web application.
# It installs necessary PHP extensions, enables Apache rewrite module, sets the document root,
# copies application files, sets permissions, installs dependencies, and sets the entrypoint.

FROM serversideup/php:8.3-fpm-apache

USER root

# Install PHP extensions
RUN install-php-extensions intl gd zip fileinfo exif

# Enable Apache rewrite and headers module
RUN a2enmod rewrite headers

# Set Apache document root
ENV APACHE_DOCUMENT_ROOT=/var/www/html

# Add lines to the custom vhost template file, ensuring a new line before the block
RUN echo "\n<IfModule mod_setenvif.c>" >> /etc/apache2/vhost-templates/http.conf \
    && echo "    SetEnvIf X-Forwarded-Proto \"^https$\" HTTPS" >> /etc/apache2/vhost-templates/http.conf \
    && echo "</IfModule>" >> /etc/apache2/vhost-templates/http.conf

RUN echo "\n<IfModule mod_headers.c>" >> /etc/apache2/vhost-templates/http.conf \
    && echo "    Header always set X-XSS-Protection \"1; mode=block\"" >> /etc/apache2/vhost-templates/http.conf \
    && echo "    Header always set X-Content-Type-Options \"nosniff\"" >> /etc/apache2/vhost-templates/http.conf \
    && echo "    Header always set X-Frame-Options \"SAMEORIGIN\"" >> /etc/apache2/vhost-templates/http.conf \
    && echo "    Header always set Referrer-Policy \"no-referrer-when-downgrade\"" >> /etc/apache2/vhost-templates/http.conf \
    && echo "</IfModule>" >> /etc/apache2/vhost-templates/http.conf

# Change ownership of the document root
RUN chown -R www-data:www-data /var/www/html

# Set user to www-data
USER www-data


# Set working directory
WORKDIR /var/www/html


# Copy application files witht the correct permissions
COPY --chown=www-data:www-data . .

# Expose port 80
EXPOSE 8080