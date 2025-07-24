![Dockered iTop](/addons/documentation/images/dockered_itop.png)



This repository contains a Docker environment for running iTop, an open-source IT service management tool.\
The environment is designed to be easy to set up and use, with all necessary components included in the Docker Compose file.


## Documentation

📓 [Quick Start: Windows WSL2](./addons/documentation/quick_start_windows_wsl.md)

📓 [Quick Start: Ubuntu](./addons/documentation/quick_start_ubuntu.md)

📓 [How To](./addons/documentation/how_to.md)

📓 [PhpStorm Tips](./addons/documentation/phpstorm.md)

📓 [PHP Switcher Browser Extension](./addons/documentation/browser_extension.md)

📓 [iTop installation](./addons/documentation/itop_installation.md)

📓 [Docker commands](./addons/documentation/docker.md)

📓 [Troubleshooting](./addons/documentation/troubleshooting.md)

## Docker containers

Find below, a short description of the containers available in the Docker environment.

![Docker Infra](/addons/documentation/images/docker_infra.png)

> [!TIP]
> Containers ports can be modified in the `.env.local` file if they don't suit your need or are already used by others applications.

### Web Servers
The containers in charge of serving the web pages.

> [!TIP]
> You can change the default web server. [How To...](./addons/documentation/how_to.md#change-the-webserver)

#### Default Listened Ports
* `74` Serve pages based on PHP 7.4.
* `80` Serve pages based on PHP 8.0.
* `81` Serve pages based on PHP 8.1.
* `82` Serve pages based on PHP 8.2.
* `83` Serve pages based on PHP 8.3.
* `84` Serve pages based on PHP 8.4.


* `88` (Automatic Mode) To serve pages based on PHP version passed in request header `X-PHP-Version`.
* `443` (Automatic Mode) To serve pages based on PHP version passed in request header `X-PHP-Version` with `HTTPS` protocol.

#### Automatic Mode
With automatic mode, web servers will serve pages based on the PHP version passed in the request header `X-PHP-Version`.\
A [browser extension](./addons/documentation/browser_extension.md) (Chrome and Firefox) is provided to easily switch between PHP versions.\
You also can use one of the official browser extensions allowing to add custom headers then set yourself the desired PHP version.

![PHP auto](/addons/documentation/images/docker_php_auto.png)


#### Nginx (default)
The container for Nginx webserver.\
A `self-signed certificate` is included in the certs conf directory allowing `HTTPS`.

Official build of Nginx.\
Based on `nginx:alpine`

🐳 [Docker official image page](https://hub.docker.com/_/nginx)

> [!NOTE]
> `app.conf` file is included in the nginx conf directory to configure Nginx settings. [How To...](./addons/documentation/how_to.md#edit-configuration)

#### Apache
The container for Apache webserver.\
A `self-signed certificate` is included in the certs conf directory allowing `HTTPS`.

Official build of Apache.\
Based on `httpd:latest`

🐳 [Docker official image page](https://hub.docker.com/_/httpd)

> [!NOTE]
> `httpd.conf` file is included in the apache conf directory to configure Apache settings. [How To...](./addons/documentation/how_to.md#edit-configuration-1)\
`httpd-vhosts.conf` file is included in the apache conf directory to configure virtual hosts. [How To...](./addons/documentation/how_to.md#edit-configuration-1)

### PHP FPM from 7.4 to 8.4
The containers in charge of the PHP script processing.\
Based on `php:x.x-fpm` image, this extended image includes `xdebug`, all needed `php extensions`, `graphviz` and a `MariaDB client` to run iTop.

While designed for web development, the PHP scripting language also provides general-purpose use.

🐳 [Docker official image page](https://hub.docker.com/_/php)

> [!NOTE]
> `php.ini` file is included in the php conf directory to configure PHP settings. [How To...](./addons/documentation/how_to.md#change-PHP-settings)\
`xdebug.ini` file is included in the php conf directory to configure XDebug settings. [How To...](./addons/documentation/how_to.md#change-XDebug-settings)

> [!TIP]
> You can  add a new PHP version. [How To...](./addons/documentation/how_to.md#add-a-new-php-version)

### MariaDB
The container for MariaDB database.

MariaDB Server is a high performing open source relational database, forked from MySQL.\
Based on `mariadb` image.

🐳 [Docker official image page](https://hub.docker.com/_/mariadb)


#### Default Listened Ports
* `3306`

### MySQL
The container for MySQL database.

MySQL is a widely used, open-source relational database management system (RDBMS).
Based on `mysql` image.

🐳 [Docker official image page](https://hub.docker.com/_/mysql)

#### Default Listened Ports
* `3307`

### Adminer
The container for database web administration.

Database management in a single PHP file.
Based on `adminer` image.

🐳 [Docker official image page](https://hub.docker.com/_/adminer)

#### Default Listened Ports
* `8080`

### MailPit
The container for mailer testing.

Mailpit is packed full of features for developers wanting to test SMTP and emails. It acts as an SMTP server, provides a modern web interface to view & test intercepted emails. It also contains an API for automated integration testing.
Based on `axllent/mailpit` image.

🐳 [Docker official image page](https://hub.docker.com/r/axllent/mailpit)

#### Default Listened Ports
* `8025` WebUI
* `1025` SMTP







