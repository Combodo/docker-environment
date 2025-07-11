ARG IMAGE=php:8.1-fpm
ARG XDEBUG_VERSION=3.4.1

FROM ${IMAGE}

ARG XDEBUG_VERSION

# Update packages list
RUN apt-get update

# Install @mariadb-client & @graphviz
RUN apt-get install mariadb-client graphviz -y

# Install @gd
RUN apt-get install -y \
		libfreetype-dev \
		libjpeg62-turbo-dev \
		libpng-dev \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install -j$(nproc) gd

# Install @mysqli
RUN docker-php-ext-install mysqli

# Install @saop
RUN apt-get install -y libxml2-dev
RUN docker-php-ext-install soap

# Install @zip
RUN apt-get install -y \
        libzip-dev \
        zip \
  && docker-php-ext-install zip

# Install @apcu
RUN pecl install APCu && \
    docker-php-ext-enable apcu

# Install @ldap
RUN \
apt-get install libldap2-dev -y && \
rm -rf /var/lib/apt/lists/* && \
docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
docker-php-ext-install ldap

# Install @xdebug
RUN pecl install xdebug-${XDEBUG_VERSION} \
    && docker-php-ext-enable xdebug
