FROM php:7.0-apache

# Allow modrewrite
RUN a2enmod rewrite

RUN apt-get update && apt-get install -y --no-install-recommends \
        curl \
        git \
        less \
        nano \
        vim \
        unzip \
        libzip-dev \
        && docker-php-ext-install zip

# download and check composer (may need to update hash in future)
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php \
    && php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"

# install globally
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && composer -v \
    && rm composer-setup.php

RUN echo 'export PATH="$PATH:$HOME/.composer/vendor/bin"' >> /${USER}/.bashrc

# install kirby-cli
RUN composer global require getkirby/cli

WORKDIR /var/www/html/

VOLUME ["/var/www/html/"]

EXPOSE 80

