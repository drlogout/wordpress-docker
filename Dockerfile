FROM wordpress:php7.2-apache

ENV DEBIAN_FRONTEND noninteractive

RUN bash -c 'debconf-set-selections <<< "postfix postfix/main_mailer_type select Satellite system"' && \
    bash -c 'debconf-set-selections <<< "postfix postfix/mailname string $HOSTNAME"' && \
    bash -c 'debconf-set-selections <<< "postfix postfix/relayhost string $SMTP_HOST"'

RUN apt-get update && \
    apt-get install -y \
        ansible \
        git \
        libsasl2-modules \
        mailutils \
        postfix && \
    rm -rf /var/lib/apt/lists/*

ADD ansible /ansible

WORKDIR /ansible
RUN ansible-galaxy install -r requirements.yml

COPY docker-entrypoint.sh /usr/local/bin/
COPY php.ini /usr/local/etc/php/conf.d/docker-php-custom.ini

WORKDIR /var/www/html

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
