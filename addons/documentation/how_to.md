🔙 [Back to readme page](../../readme.md)
# How to
Tips for the common operations you may need to do with the docker environment.

## Table of Contents

- [Docker environment](#docker-environment)
  - [Update procedure](#update-procedure)
- [PHP](#php)
  - [Change PHP settings](#change-php-settings)
  - [Change XDebug settings](#change-xdebug-settings)
  - [Change MariaDB client settings](#change-mariadb-client-settings)
  - [Add a new php version](#add-a-new-php-version)
- [Web Server](#web-server)
  - [Change the webserver](#change-the-webserver)
  - [Change html folder](#change-html-folder)
  - [Nginx](#nginx)
    - [Edit configuration and virtual hosts](#edit-configuration-and-virtual-hosts)
  - [Apache](#apache)
    - [Edit configuration](#edit-configuration)
    - [Edit virtual hosts](#edit-virtual-hosts)
- [Databases](#databases)
  - [Change data folder](#change-data-folder)
  - [Import/Export database dump](#importexport-database-dump)
  - [MariaDB](#mariadb)
    - [Connect from host](#connect-from-host)
    - [Edit configuration](#edit-configuration-1)
  - [MySQL](#mysql)
    - [Connect from host](#connect-from-host-1)
    - [Edit configuration](#edit-configuration-2)
  - [Activate secured connection](#activate-secured-connection)
    - [TLS/SSL](#tlsssl)
    - [Certificate validation](#certificate-validation)
- [Adminer](#adminer)
  - [See database data](#see-database-data)
- [MailPit](#mailpit)
  - [Debug mailer](#debug-mailer)
  - [Configure Relay and Forwarding](#configure-relay-and-forwarding)
- [Script-server](#script-server)
  - [Add a script](#add-a-script)

## Docker environment

### Update procedure
Updating this Docker environment to the latest version allows you to get the latest improvements and bug fixes such as new services, new scripts and new env. variables.

Whether you cloned the Git repository or extracted a zip archive of the project, starting with v0.3.0, all you have to do is run the auto update script which:
  * Update project files
  * Deploy default configuration files
  * Add any new env. variable in your `.env.local` file with default values
  * Rebuild and restart the containers

To do so, simply run the following command from the project root folder:

```bash
./auto-update.sh
```

<details>
<summary>How to upgrade from a version older than v0.3.0</summary>

If you are using an old version that doesn't have the `auto-update.sh` script, follow these steps to get up to speed:
  * Download the latest version of the `auto-update.sh` script [here](https://github.com/Combodo/docker-environment/blob/master/auto-update.sh).
  * Place it in the root folder of your docker environment (most likely `docker-environment` or `docker_environment` folder).
  * Make it executable by running the command: `chmod +x auto-update.sh`.
  * Fix your `.env` file by putting single quotes around the `MAILPIT_RELAY_MATCHING` value, for example:
    * Replace `MAILPIT_RELAY_MATCHING=(user\.combodo@gmail\.com|user@combodo\.com)`
    * With `MAILPIT_RELAY_MATCHING='(user\.combodo@gmail\.com|user@combodo\.com)'`
  * Fix your `.env.local` file the same way if you have one.

You can now run the auto update script as described above!
</details>

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

### Change MariaDB client settings
Modify the `client.cnf` file in the php conf directory then restart the container.\
Note that this file is used by both MariaDB and MySQL clients.\

### Add a new php version
  * Duplicate a php section in `docker-compose.yml` then run `docker compose up -d`.\
  * Bind a port in the web server then edit the server configuration to add a new virtual host.\
  * Add the new php version in the Chrome extension if using it.\
  * Add the new php version in the Script Server script that runs the CRON job (`build/default_configuration/script-server/conf/runners/itop_run_cron.json`).

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

#### Import from database container
You can put the dump file from the docker host in the `data/dbdump` folder then connect to the database container with `docker exec -it <container> bash` and use the command line to import your dump.

```bash
mariadb --user <user> --password <database_name> < /tmp/dbdump/dump_file.sql
```

#### Import from docker host
You can directly import the dump file from the host with the following command:

```bash
docker exec -i <mariadb|mysql> <mariadb-dump|mysqldump> -u <user> -p <database_name> < data/dbdump/dump_file.sql
```

#### Export from database container
Connect to the database container with `docker exec -it <container> bash` then use the command line to export your dump then you can find the dump file from the docker host in the `data/dbdump` folder.

```bash
mariadb-dump --user <user> --password <database_name> > /tmp/dbdump/dump_file.sql
```

#### Export from docker host
You can directly export the dump file from the host with the following command:

```bash
docker exec -i <mariadb|mysql> <mariadb-dump|mysqldump> -u <user> -p <database_name> > data/dbdump/dump_file.sql
```

> [!IMPORTANT]
> mysqldump is lot longer available in the mariadb container, you have to use `mariadb-dump` instead.

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

### Activate secured connection
If you want to activate secured connection to your database.

> [!NOTE]
> Adminer is already configured to connect to the database with SSL, so no need to change its configuration.

#### TLS/SSL
Activate the flag `require_secure_transport = ON` in the corresponding `my.cnf` file from the database conf directory then restart the container.\
You also need to set `db_tls.enabled' => true` in iTop configurations.

> [!CAUTION]
> When you make backup from iTop with SSL on a MySQL server, you will get an error "--ssl-mode is not recognized" because iTop use a mySQL parameter on a MariaDB client.\
In that case, you will need to perform the dump as describes in the [Import/Export database dump](#importexport-database-dump) section.

#### Certificate validation
Validate secured connection with a certificate to be sure that you are connecting to the right.

On MariaDB, to force the validation of a certificate, set the flag `ssl_verify_client_cert = ON` in the corresponding `my.cnf` file from the database conf directory then restart the container.\
However, this seems to not be fully compatible with the MariaDB docker image.

For MySQL or if you want to have a workaround for MariaDB,
you can force certificate validation for a specific user by creating it with the `REQUIRE X509` option in your database.\

```sql
CREATE USER 'secure_user'@'%' IDENTIFIED BY 'password' REQUIRE X509;
GRANT ALL PRIVILEGES ON *.* TO 'secure_user'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```

### Change user password

```sql
ALTER USER 'root'@'%' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
```


To use certificate in iTop, set the `'db_tls.ca' => '/etc/database/certs/ca.pem',` in iTop global configuration.

> [!NOTE]
> The certificate provided in the `conf/certs/database` folder is targeted for mysql container, so you may have `Peer certificate CN=mysql' did not match expected CN=`mariadb'` error in iTop with mariadb.

> [!WARNING]
> Certificate validation is not fully implemented in iTop.

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

There's also a local SMTP server running on PHP's container allowing you to redirect to MailPit without changing the application configuration.
If you changed mailpit port, change it also in the following file `conf/msmtprc/msmtprc`.
```php
	// email_transport: Mean to send emails: PHPMail (uses the function mail()), SMTP (implements the client protocol) or SMTP_OAuth (connect to the server using OAuth 2.0)
	//	default: 'PHPMail'
	'email_transport' => 'PHPMail',
```

### Configure Relay and Forwarding

Relay is activated by default, so you can use MailPit as a relay server to forward emails to another SMTP server.\
You can specify witch recipient are candidates to relay via en environment variable `MAILPIT_RELAY_MATCHING` in the `.env.local` file.\

A forwarding configuration is also available to forward emails to another SMTP server.
Refer to the official documentations for more information.

https://mailpit.axllent.org/docs/configuration/smtp-forward/

https://mailpit.axllent.org/docs/configuration/smtp-relay/


## Script-server

### Add a script

  * Add your script file in `data/script-server/scripts` folder.
  * Add a configuration file in `conf/script-server/config/runners` folder describing your script (name, description, parameters, ... Full documentation [here](https://github.com/bugy/script-server/wiki/Script-config)).
  * Restart the script-server container.

## kCacheGrind

### Open a cachegrind file

  * Open the kcachegrind application http://localhost:8088/vnc.html?path=vnc&autoconnect=true&resize=remote&reconnect=true&show_dot=true.
  * Click on "File" then "Open" and select the cachegrind file you want to open from the `data` folder.


\
\
🔙 [Back to readme page](../../readme.md)
