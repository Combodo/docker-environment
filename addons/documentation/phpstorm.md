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

Choose `Docker Compose` and set the following options:\
Choose the php service you want to use from the list (e.g. `php84`).

![CLI Edit](/addons/documentation/images/phpstorm/cli_edit.png)

Open the environment variables editor.\
Set the `CONF_FOLDER` and `HTML_FOLDER` variables as in the `.env.local` file of your `docker_environment` instance.

![CLI Env Vars](/addons/documentation/images/phpstorm/cli_env_vars.png)

Confirm the settings, then choose the `Connect to an existing container` option, in the `Lifecycle` section.

![CLI Lifecycle](/addons/documentation/images/phpstorm/cli_interpreter_edit.png)

You need to set addition information from php section.

![CLI Settings](/addons/documentation/images/phpstorm/cli_settings.png)

First set `path mappings` for the project.\
Set the correct location of your project.

> [!WARNING]
> You will have to set the path mappings for every projects, its not a shared setting.

![CLI Path Mapping](/addons/documentation/images/phpstorm/cli_path_mapping.png)

Add other php versions as needed.

## Setup Services

In the PhpStorm services view, click on the `+` button and choose `Docker, Connection, WSL...`.\
You will have access to docker containers and images.

![Services](/addons/documentation/images/phpstorm/services.png)

This is easy from here to control container and see logs.

![Services](/addons/documentation/images/phpstorm/services_container_log.png)

You may also perform terminal commands in the container.

![Services](/addons/documentation/images/phpstorm/services_container_terminal.png)

## Open a terminal inside the WSL2 host

Inside PHPStorm's terminal pane, using the dropdown arrow allows you to select the `dockered-itop` WSL2 host, where you can run commands to [install iTop](./itop_installation.md).

![Services](/addons/documentation/images/phpstorm/wsl2_terminal.png)

## Xdebug
Open the iTop project in PHPStorm.

### Debugger
In PHPStorm settings, under PHP > Debug, you can uncheck these options :
- Xdebug
  - [ ] Force break at first line when no path mapping specified
  - [ ] Force break at first line when a script is outside the project
- Evaluation
  - Settings
    - [ ] Notify if debug session was finished without being paused

### Servers
In PHPStorm settings, under PHP > Servers, add a new server with the following configuration :
- Host : localhost
- Port : 88
- Debugger : Xdebug


Check the following option to configure path mappings :
- [X] Use path mappings (select if the server is remote or symlinks are used)
- Add a target to the default option from `//wsl.localhost/dockered-itop/home/{your-username}/docker_environment/html/iTop` (which should already be filled in with the appropriate user) to `/var/www/html/iTop`.

\
\
🔙 [Back to readme page](../../readme.md)