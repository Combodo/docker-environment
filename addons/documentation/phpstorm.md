🔙 [Back to readme page](../../readme.md)
# PHPStorm Tips
Tips for using PHPStorm with Docker.

## Setup Database Connection

Go to database view, choose `Add >> Database Source >> MariaDB`

![Database Create](/addons/documentation/images/phpstorm/database_create.png)

Set localhost with the port defined in docker compose file (3306 by default).
Set password defined in `.env` file.

![Database](/addons/documentation/images/phpstorm/database.png)

## Import a Dump File

> [!WARNING]
> We haven't successfully imported dump files from PhpStorm yet. You can use the command line way [How To...](how_to.md#import-dump)



## Setup PHP CLI Interpreter

Go to PHP CLI interpreter settings section `File >> Settings >> Languages & Frameworks >> PHP`

Click on the `...` button to add a new interpreter.\
Click on `+` button and choose `From Docker, Vagrant, VM, WSL...`

![CLI](/addons/documentation/images/phpstorm/cli.png)

Choose `Docker` and set the following options:\
Choose the php image you want to use from the list `php:8.1-fpm`

![CLI Edit](/addons/documentation/images/phpstorm/cli_edit.png)

Create a new server and set the following options:\
Choose `WSL` with your `docker host`.

![CLI Docker Server](/addons/documentation/images/phpstorm/docker_server.png)

You need to set addition information from php section.

![CLI Settings](/addons/documentation/images/phpstorm/cli_settings.png)

First set `path mappings` for the project.\
Set the correct location of your project.

![CLI Path Mapping](/addons/documentation/images/phpstorm/cli_path_mapping.png)

Then set `container settings` for the project.\
You need to set the `network name` dockered_itop_default.

![CLI Container Settings](/addons/documentation/images/phpstorm/cli_container_settings.png)

Add other php versions as needed.

## Setup Services

In the PhpStorm services view, click on the `+` button and choose `Docker, Connection, WSL...`.\
You will have access to docker containers and images.

![Services](/addons/documentation/images/phpstorm/services.png)

This is easy from here to control container and see logs.

![Services](/addons/documentation/images/phpstorm/services_container_log.png)

You may also perform terminal commands in the container.

![Services](/addons/documentation/images/phpstorm/services_container_terminal.png)

## Open a terminal inside the WSL2 container

Inside PHPStorm's terminal pane, using the dropdown arrow allows you to select the `dockered-itop` WSL2 container, where you can run commands to [install iTop](./itop_installation.md).

![Services](/addons/documentation/images/phpstorm/wsl2_terminal.png)

## Xdebug
Open a PHPStorm instance to open the iTop root folder. You should not use the PHPStorm instance used for the docker_environment project.

In PHPStorm settings, under PHP > Debug, you can uncheck these options :
- [ ] Force break at first line when no path mapping specified
- [ ] Force break at first line when a script is outside the project

In PHPStorm settings, under PHP > Servers, add a new server with the following configuration :
- Host : localhost
- Port : 88
- Debugger : Xdebug

### WSL2-specific configuration
In PHPStorm settings, under PHP > Servers, in your server configuration, add a path mapping from `//wsl.localhost/dockered-itop/home/{your-username}/docker_environment/html/iTop` to `/var/www/html/iTop`, making sure you replace `{your-username}` with the appropriate value.

\
\
🔙 [Back to readme page](../../readme.md)