printf "%s" "Enter container name: "
read container

docker exec -it $container bash