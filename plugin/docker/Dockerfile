FROM ubuntu:bionic

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
    php7.3-cli \
    curl \
    php7.3-curl \
    php7.3-gd \
    php7.3-mbstring \
    php7.3-zip \
    php7.3-dom \
    php7.3-mysql \
    php7.3-xdebug \
    git \
    zip \
    unzip \
    jq \
    less \
    ca-certificates \
    mariadb-client

RUN curl -L https://github.com/composer/composer/releases/download/1.10.5/composer.phar -o /usr/local/bin/composer && chmod +x /usr/local/bin/composer

ARG XDEBUG=/etc/php/7.3/cli/conf.d/20-xdebug.ini
RUN echo "[XDebug]" >> ${XDEBUG} \
    && echo "xdebug.remote_enable = 1" >> ${XDEBUG} \
    && echo "xdebug.remote_autostart = 1" >> ${XDEBUG} \
    && echo "xdebug.remote_host = host.docker.internal" >> ${XDEBUG}

# Put composer stuff to path so it is easy to run codecept
ENV PATH="/app/vendor/bin:${PATH}"
ENV WP_DOCKER=1

# wp-install can be sometimes too slow for composer
ENV COMPOSER_PROCESS_TIMEOUT=3600

RUN mkdir -p /app
WORKDIR /app

RUN adduser --disabled-password --gecos "" wp
USER wp

EXPOSE 8080

CMD ["/app/docker/init.sh"]