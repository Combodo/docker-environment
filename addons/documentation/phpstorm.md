🔙 [Back to readme page](../../readme.md)
# PHPStorm Tips
Tips for using PHPStorm with Docker.

## Setup Database Connection

Go to database view, choose `Add >> Database Source >> MariaDB`

![Database Create](/addons/documentation/images/phpstorm_database_create.png)

Set localhost with the port defined in docker compose file (3306 by default).
Set password defined in `.env` file.

![Database](/addons/documentation/images/phpstorm_database.png)

## Setup PHP CLI Interpreter

Go to PHP CLI interpreter settings section `File >> Settings >> Languages & Frameworks >> PHP`

Click on the `...` button to add a new interpreter.\
Click on `+` button and choose `From Docker, Vagrant, VM, WSL...`

![CLI](/addons/documentation/images/phpstorm_cli.png)

Choose `Docker` and set the following options:\
Choose the php image you want to use from the list `php:8.1-fpm`

![CLI Edit](/addons/documentation/images/phpstorm_cli_edit.png)

Create a new server and set the following options:\
Choose `WSL` with your `docker host`.

![CLI Docker Server](/addons/documentation/images/phpstorm_docker_server.png)

You need to set addition information from php section.

![CLI Settings](/addons/documentation/images/phpstorm_cli_settings.png)

First set `path mappings` for the project.\
Set the correct location of your project.

![CLI Path Mapping](/addons/documentation/images/phpstorm_cli_path_mapping.png)

Then set `container settings` for the project.\
You need to set the `network name` dockered_itop_default.

![CLI Container Settings](/addons/documentation/images/phpstorm_cli_container_settings.png)

Add other php versions as needed.

## Setup Services

In the PhpStorm services view, click on the `+` button and choose `Docker, Connection, WSL...`.\
You will have access to docker containers and images.

![Services](/addons/documentation/images/phpstorm_services.png)

This is easy from here to control container and see logs.

![Services](/addons/documentation/images/phpstorm_services_container_log.png)

You may also perform terminal commands in the container.

![Services](/addons/documentation/images/phpstorm_services_container_terminal.png)

\
\
🔙 [Back to readme page](../../readme.md)