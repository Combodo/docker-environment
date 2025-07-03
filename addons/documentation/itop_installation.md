🔙 [Back to readme page](../../readme.md)
# iTop installation
> [!WARNING]
> **All these steps are to be executed [inside the dockered-itop container](./phpstorm.md#open-a-terminal-inside-the-wsl2-container).**

## Change the current working directory
`cd html`

## Install iTop
`git clone https://github.com/Combodo/iTop.git`

## Update iTop ownership
`sudo chown www-data: iTop -R`

## Configure iTop
Visit http://localhost:88/iTop/ to start configuring the software.

![Prerequisites](/addons/documentation/images/itop_install/wizard1-prerequisites.png "Prerequisites")

You should be welcomed with a screen like above where prerequisites are ok, and you may have a security warning regarding the `AllowOverride` directive for Apache if you are using Nginx instead (which is the default configuration).

Click `Continue`.

![Installation Type](/addons/documentation/images/itop_install/wizard2-installation-type.png "Installation Type")

Select `Install a new iTop` then click `Next`.

![License Agreement](/addons/documentation/images/itop_install/wizard3-license-agreement.png "License Agreement")

Check both inputs :
- [x] I accept the terms of the licenses of the 103 components mentioned above.
- [x] I accept the processing of my personal data

Click `Next`.

![Database Configuration](/addons/documentation/images/itop_install/wizard4-database-configuration.png "Database Configuration")

- The `Server Name` field should contain the name of the docker container hosting your database. `mariadb` is the one used by default, `mysql` is also available.
- The `Login` field should contain `root`.
- The `Password` field should contain the value set in the `.env` file for the `MARIADB_ROOT_PASSWORD` or `MYSQL_ROOT_PASSWORD` key depending on the container you chose in the `Server Name` field.

Click `Next`.

![Admin Account Config](/addons/documentation/images/itop_install/wizard5-admin-account-config.png "Admin Account Config")

Define your iTop admin account with a login and password of your choice.

Click `Next`.

The following screens allow you to set different options, you can read those, the default ones are good to get started so no change is needed here.

![Summary](/addons/documentation/images/itop_install/wizard12-summary.png "Summary")

When reaching the summary, you can click `Install`.

![Installation](/addons/documentation/images/itop_install/wizard13-installation.png "Installation")

Wait for the installation to complete, this should only take a few seconds.

![Success](/addons/documentation/images/itop_install/wizard14-success.png "Success")

You should see a success message. Click `Enter iTop` to start using the software.

\
\
🔙 [Back to readme page](../../readme.md)