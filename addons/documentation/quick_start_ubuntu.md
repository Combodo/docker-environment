🔙 [Back to readme page](../../readme.md)

# Quick start: Ubuntu
Follow these instructions to run dockered-itop on Ubuntu.

## 1️⃣ Install Docker


## 2️⃣ Run environment

From terminal

* Clone dockered-itop project\
  ```git clone https://github.com/Combodo/docker_environment.git```


* Change current directory to dockered-itop directory\
  ```cd dockered_itop```


* Copy the containers default configuration files\
  ```cp -R build/default_configuration/* conf```


* Create a copy of `.env` file as `.env.local` to set your own configuration, like data folders, database password, web server you want to use, ports....
  ```cp .env .env.local```

* Run docker-compose\
  ```docker-compose up -d```

## ️✅ You are ready to go!

You can now access web resources here [http://localhost:80](http://localhost:80/phpinfo.php)

\
\
🔙 [Back to readme page](../../readme.md)
