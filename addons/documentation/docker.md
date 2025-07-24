🔙 [Back to readme page](../../readme.md)
# Docker Commands
Useful commands for docker.

### Launch docker environment

Run `docker compose up -d` with host bash in the project root directory.

Use `--force-recreate` to force the recreation of containers.

[Official documentation](https://docs.docker.com/compose/reference/up/)

### Shut down docker environment

Run `docker compose down` with host bash in the project root directory.

[Official documentation](https://docs.docker.com/compose/reference/down/)

### Restart a container

Run `docker container restart <container>` with host bash in the project root directory or use action button in the PhpStorm container view.

[Official documentation](https://docs.docker.com/engine/reference/commandline/container_restart/)

### Open a container terminal

Run `docker exec -it <container> bash` with host bash in the project root directory or open Docker Desktop and open a terminal in the PhpStorm container view.

[Official documentation](https://docs.docker.com/engine/reference/commandline/exec/)

### Show statistics

Run `docker stats`

[Official documentation](https://docs.docker.com/engine/reference/commandline/stats/)


> [!TIP]
> If you use PhpStorm, you can use service view to perform main actions. You can also find plugin for Visual Studio Code.

\
\
🔙 [Back to readme page](../../readme.md)