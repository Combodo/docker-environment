![Dockered iTop](/addons/documentation/images/dockered_itop.png)



This repository contains a Docker environment for running iTop, an open-source IT service management tool.\
The environment is designed to be easy to set up and use, with all necessary components included.

> [!WARNING]
> Mind that this environment is intended for development and testing purposes only.\
> It should not be used for production.


## Documentation

📓 [Quick Start: Windows WSL2](./addons/documentation/quick_start_windows_wsl.md)

📓 [Quick Start: Ubuntu](./addons/documentation/quick_start_ubuntu.md)

📓 [iTop installation](./addons/documentation/itop_installation.md)

📓 [How To](./addons/documentation/how_to.md)

📓 [PhpStorm Tips](./addons/documentation/phpstorm.md)

📓 [PHP Switcher Browser Extension](./addons/documentation/browser_extension.md)

📓 [Docker Useful Commands](./addons/documentation/docker.md)

📓 [Troubleshooting](./addons/documentation/troubleshooting.md)

## Docker containers

Find below, a short description of containers available in the Docker environment.

![Docker Infra](/addons/documentation/images/docker_infra.png)

> [!TIP]
> Containers ports can be modified in the `.env.local` file if they don't suit your need or are already used by others applications.

### Web Servers
The containers in charge of serving the web pages.

> [!TIP]
> You can change the default web server. [How To...](./addons/documentation/how_to.md#change-the-webserver)

#### Default Listened Ports
* `88` (Automatic Mode) To serve pages based on PHP version passed in request header `X-PHP-Version`.
* `443` (Automatic Mode) To serve pages based on PHP version passed in request header `X-PHP-Version` with `HTTPS` protocol.
* `74` Serve pages based on PHP 7.4.
* `80` Serve pages based on PHP 8.0.
* `81` Serve pages based on PHP 8.1.
* etc... (depending on the number of PHP versions you have, until 88 😬)

#### Automatic Mode
With automatic mode, web servers will serve pages based on the PHP version passed in the request header `X-PHP-Version`.\
A [browser extension](./addons/documentation/browser_extension.md) (Chrome and Firefox) is provided to easily switch between PHP versions.\
You also can use one of the official browser extensions allowing to add custom headers then set yourself the desired PHP version.\
`X-PHP-Version = 82` for PHP 8.2.

![PHP auto](/addons/documentation/images/docker_php_auto.png)


#### Nginx (default)
Nginx webserver.\
Official build of Nginx based on `nginx:alpine` 🐳 [Docker official image page](https://hub.docker.com/_/nginx)

> [!NOTE]
> A self-signed certificate is included in the certs webserver conf directory allowing `HTTPS`.

> [!NOTE]
> `app.conf` file is included in the nginx conf directory to configure Nginx settings. [How To...](./addons/documentation/how_to.md#edit-configuration)

#### Apache
Apache webserver.\
Official build based on `httpd:latest` 🐳 [Docker official image page](https://hub.docker.com/_/httpd)

> [!NOTE]
> A self-signed certificate is included in the certs webserver conf directory allowing `HTTPS`.

> [!NOTE]
> `httpd.conf` file is included in the apache conf directory to configure Apache settings. [How To...](./addons/documentation/how_to.md#edit-configuration-1)\
`httpd-vhosts.conf` file is included in the apache conf directory to configure virtual hosts. [How To...](./addons/documentation/how_to.md#edit-configuration-1)

### PHP FPM X.X
While designed for web development, the PHP scripting language also provides general-purpose use.\
Custom build based on `php:x.x-fpm` image, this extended image includes `xdebug`, all needed `php extensions`, `graphviz` and a `MariaDB client` to run iTop 🐳 [Docker official image page](https://hub.docker.com/_/php)

> [!NOTE]
> `php.ini` file is included in the php conf directory to configure PHP settings. [How To...](./addons/documentation/how_to.md#change-PHP-settings)\
`xdebug.ini` file is included in the php conf directory to configure XDebug settings. [How To...](./addons/documentation/how_to.md#change-XDebug-settings)\
`client.cnf` file is included in the php conf directory to configure MariaDB/MySQL client settings. [How To...](./addons/documentation/how_to.md#change-MariaDB-client-settings)

> [!TIP]
> You can  add a new PHP version. [How To...](./addons/documentation/how_to.md#add-a-new-php-version)

### MariaDB
MariaDB Server is a high performing open source relational database, forked from MySQL.\
Official build based on `mariadb` image. 🐳 [Docker official image page](https://hub.docker.com/_/mariadb)

> [!NOTE]
> Certificates are included in the certs database conf directory allowing secured connection to the database.

> [!IMPORTANT]
> `require_secure_transport` flag is set to `OFF` in the default configuration of the database.\
If you want to enable it, you can change the `my.cnf` file included in the database conf directory. [How To...](./addons/documentation/how_to.md#activate-secured-connection)\

#### Default Listened Ports
* `3306`

### MySQL
MySQL is a widely used, open-source relational database management system (RDBMS).\
Official build based on `mysql` image. 🐳 [Docker official image page](https://hub.docker.com/_/mysql)

> [!NOTE]
> Certificates are included in the certs database conf directory allowing secured connection to the database.

> [!IMPORTANT]
> `require_secure_transport` flag is set to `OFF` in the default configuration of the database.\
If you want to enable it, you can change the `my.cnf` file included in the database conf directory. [How To...](./addons/documentation/how_to.md#edit-configuration-2)\
You also need to set `'db_tls.enabled' => true` in iTop configurations.

#### Default Listened Ports
* `3307`

### Adminer
Database management in a single PHP file.\
Official build based on `adminer` image. 🐳 [Docker official image page](https://hub.docker.com/_/adminer)

#### Default Listened Ports
* `8080`

### MailPit
Mailpit is packed full of features for developers wanting to test SMTP and emails. It acts as an SMTP server, provides a modern web interface to view & test intercepted emails. It also contains an API for automated integration testing.\
Official build based on `axllent/mailpit` image. 🐳 [Docker official image page](https://hub.docker.com/r/axllent/mailpit)

#### Default Listened Ports
* `8025` WebUI
* `1025` SMTP

### Script-server
Script-server allows you to execute pre-configured CLI scripts directly from a Web UI. No need for SSH connection, knowing commands exact syntax.\
Official build based on `bugy/script-server` image. 🐳 [Docker official image page](https://hub.docker.com/r/bugy/script-server)

#### Default Listened Ports
* `8090` WebUI

### kCacheGrind
Web GUI to inspect Valgrind and Xdebug profiling reports.\
Official build based on `nedix/kcachegrind` image. 🐳 [Docker official image page](https://hub.docker.com/r/nedix/kcachegrind)

#### Default Listened Ports
* `8088` WebUI





