🔙 [Back to readme page](../../readme.md)

# Quick start: Windows WSL2
Follow these instructions to install and run dockered-itop on Windows.

## Prerequisites
Windows 10 > versions 2004 (>= build 19041) or Windows 11

## 1️⃣ Install Docker Desktop
Follow official installation instructions.\
Choose WSL2 integration during installation.

[Download Docker Desktop for Windows](https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-win-amd64)

[Official Docker installation Instructions](https://docs.docker.com/desktop/setup/install/windows-install/#install-docker-desktop-on-windows)

Once installed on your computer, Docker Desktop allow you to launch a docker environment on your Windows machine but this is not the way we will use it, due to performance consideration.\
We will use WSL2 to create a linux docker host.

## 2️⃣ Create a WSL2 host
This is the environment we will use to launch docker containers.

* Launch windows terminal


* Install a new WSL2 host\
  `wsl --install -d ubuntu --name dockered-itop`

> [!NOTE]
> Browse [How WSL2 documentation](https://learn.microsoft.com/en-us/windows/wsl/) if you need more information.

## 3️⃣ Register the new host in Docker Desktop
You need to allow running docker in our new host.\
Open Docker Desktop and go to `settings > Resources > WSL Integration` then check the new host.

![Start Menu](/addons/documentation/images/register_docker.png "Extension chrome preview")

## ️4️⃣ Run environment

* Launch host terminal  `Windows Start Menu > All apps > dockered-itop`

![Start Menu](/addons/documentation/images/wsl_launch.png "Extension chrome preview")

* Enter a username and a password.


* Configure Git credential manager [WSL2 Git configuration](https://learn.microsoft.com/fr-fr/windows/wsl/tutorials/wsl-git)\
  `git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"`


* Clone dockered-itop project\
  `git clone https://github.com/Combodo/docker_environment.git`


* Change current directory to dockered-itop directory\
  `cd dockered_itop`


* Edit `.env` file to set your own configuration, like your database password or the web server you want to use.


* (optional) Edit `docker-compose.override.yml` file to set custom ports . [How To...](./how_to.md#change-host-container-ports)


* Run docker-compose\
  `docker-compose up -d`

## ️✅ You are ready to go!

You can now access web resources here [http://localhost:80](http://localhost:80/phpinfo.php)

\
\
🔙 [Back to readme page](../../readme.md)
