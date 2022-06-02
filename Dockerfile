FROM ubuntu:20.04

RUN apt-get update -y
RUN apt install -y tzdata

RUN apt-get install apache2 libapache2-mod-php7.4 -y
RUN a2dismod php7.4
RUN a2dismod mpm_prefork
RUN a2enmod mpm_event
RUN apt-get install nano -y
RUN apt-get install php7.4-fpm -y
RUN apt-get install libapache2-mod-fcgid -y

RUN apt-get install nano -y
RUN a2enconf php7.4-fpm
RUN a2enmod proxy
RUN a2enmod proxy_fcgi
RUN a2enmod rewrite


RUN apt install zlib1g-dev  -y  \
    libxml2-dev \
    libzip-dev \
    libpq-dev \
    libonig-dev \
    zip \
    xvfb \
    curl \
    php-sysvsem \
    php-gd \
    php-pgsql \
    php-mysql \
    unzip

RUN apt install libxrender-dev libxrender1 libfontconfig1 -y

# Configuration File settings
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# Loaded Configuration File /etc/php/7.4/fpm/php.ini

RUN sed -i -e 's/upload_max_filesize = 2M/upload_max_filesize=20M/' /etc/php/7.4/fpm/php.ini
RUN sed -i -e 's/post_max_size = 8M/post_max_size=120M/' /etc/php/7.4/fpm/php.ini

COPY vhost.conf /etc/apache2/sites-available/000-default.conf

COPY my_info.php /var/www/html/

RUN service php7.4-fpm restart
RUN service apache2 restart

COPY run-entry /usr/local/bin/run-entry

RUN chmod +x /usr/local/bin/run-entry

EXPOSE 9000
ENTRYPOINT ["run-entry"]
CMD ["run-entry"]
#CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]

