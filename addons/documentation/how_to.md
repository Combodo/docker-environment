🔙 [Back to readme page](../../readme.md)
# How to
Tips for the common operations you may need to do with the docker environment.

## PHP

### Change PHP settings
Modify the `php.ini` file in the php conf directory then restart the container.\
You may also want to have a specific init file for a php version, you have to override `docker-compose.yml` volume entries to achieve this.

> [!NOTE]
> Browse [PHP settings](https://www.php.net/manual/en/ini.list.php) for more information.

> [!TIP]
> Take a look at [Chris Shennan blog article](https://chrisshennan.com/blog/10-essential-phpini-tweaks-for-improved-web-performance) for improving web performance.

### Change XDebug settings
Modify the `xdebug.ini` file in the php conf directory then restart the container.\
You may also want to have a specific init file for a php version, you have to override `docker-compose.yml` volume entries to achieve this.

> [!NOTE]
> Browse [XDebug settings](https://xdebug.org/docs/all_settings) for more information.

### Add a new php version
Duplicate a php section in `docker-compose.yml` then run `docker compose up -d`.\
Bind a port in the web server then edit the server configuration to add a new virtual host.\
Add the new php version in the Chrome extension if using it.

```yaml
  php85:
    <<: *default-php
    container_name: php8.5
    build:
      <<: *default-php-build
      args:
        IMAGE: php:8.5-fpm
        XDEBUG_VERSION: 3.4.1
```

```yaml
   nginx:
      image: nginx:alpine
      ports:
         - "85:85"
      ...
```

And only if you wish to have a specific port for this version, modify Nginx or Apache virtual hosts configuration.

```apacheconf
# PHP 8.5
server {
listen 85;
server_name localhost;
root /var/www/html/;
index index.php index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ ^(.+.\.php)(/|$) {
        fastcgi_pass php85:9000;
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
```

> [!NOTE]
> Browse [Docker PHP-FPM images](https://hub.docker.com/_/php/tags) versions.

> [!NOTE]
> Browse [XDebug PHP Compatibility table](https://xdebug.org/docs/compat).

## Web Server

### Change the webserver

Change both env var `ENABLE_NGINX`and `ENABLE_APACHE` in your `.env.local` file to `0` or `1` according to your needs.

Example for running Nginx:

````yaml
ENABLE_APACHE=0
ENABLE_NGINX=1
````

If you want both servers, set both to `1` and bind different ports in your `.env.local` file.

### Change html folder
You can change the folder used by NGINX to serve the web application in your `.env.local` file.\
Just set a new value to the `HTML_FOLDER` variable.

### Nginx

#### Edit configuration and virtual hosts
Modify the `app.conf` file in the nginx conf directory then restart the container.

### Apache

#### Edit configuration
Modify the `httpd.conf` file in the apache conf directory then restart the container.

#### Edit virtual hosts
Modify the `httpd-vhosts.conf` file in the apache conf directory then restart the container.

## Databases

### Change data folder
You can change the folder used by databases in your `.env.local` file.\
Just set a new value to the `DATA_FOLDER` variable.

### Import/Export database dump

> [!NOTE]
> A folder is mount from the host (data/dbdump) in data folder to the database container (/tmp/dbdump).

#### Import
Connect to the database container with `docker exec -it <container> bash` then use the command line to import your dump.

```bash
mariadb --user <user> --password <database_name> < /tmp/dbdump/dump_file.sql
```

#### Export
Connect to the database container with `docker exec -it <container> bash` then use the command line to import your dump.

```bash
mariadb-dump --user <user> --password <database_name> > /tmp/dbdump/dump_file.sql
```

> > [!IMPORTANT]
> mysql-dump is lot longer available in the mariadb container, you have to use `mariadb-dump` instead.

### MariaDB

#### Connect from host
According to the port defined in the `docker-compose.yml`, you can connect to the database with the following url:  [jdbc:mariadb://localhost:3306](jdbc:mariadb://localhost:3308)

#### Edit configuration
Modify the `my.cnf` file in the MariaDB conf directory then restart the container.

### MySQL

#### Connect from host
According to the port defined in the `docker-compose.yml`, you can connect to the database with the following url:  [jdbc:mariadb://localhost:3307](jdbc:mariadb://localhost:3308)

#### Edit configuration
Modify the `my.cnf` file in the MySQL conf directory then restart the container.

## Adminer

### See database data
According to the port defined in the `docker-compose.yml`, you can access the databases with the following url: [http://localhost:8080](http://localhost:8080).

## MailPit

### Debug mailer
You can debug your application mailing functionality with the following url: [http://localhost:8025](http://localhost:8025).

For iTop, you can use this default configuration:

```php
	// email_transport: Mean to send emails: PHPMail (uses the function mail()), SMTP (implements the client protocol) or SMTP_OAuth (connect to the server using OAuth 2.0)
	//	default: 'PHPMail'
	'email_transport' => 'SMTP',

	// email_transport_smtp.host: host name or IP address (optional)
	//	default: 'localhost'
	'email_transport_smtp.host' => 'mailpit',

	// email_transport_smtp.port: port number (optional)
	//	default: 25
	'email_transport_smtp.port' => '1025',
```

### Configure Relay and Forwarding

Relay is activated by default, so you can use MailPit as a relay server to forward emails to another SMTP server.\
You can specify witch recipient are candidates to relay via en environment variable `MAILPIT_RELAY_MATCHING` in the `.env.local` file.\

A forwarding configuration is also available to forward emails to another SMTP server.
Refer to the official documentations for more information.

https://mailpit.axllent.org/docs/configuration/smtp-forward/

https://mailpit.axllent.org/docs/configuration/smtp-relay/


\
\
🔙 [Back to readme page](../../readme.md)
