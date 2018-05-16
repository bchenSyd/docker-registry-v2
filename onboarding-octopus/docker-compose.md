# docker compose

start up as daemon, and stop && clean up 
//########################################################################################
       `docker-compose -f grid.yml  -d up ` && `docker-compose -f grid.yml down`
//########################################################################################


```yml
version: "3"
services:
  selenium-hub:
    image: selenium/hub
    container_name: selenium-hub
    ports:
      - "4444:4444"
  chrome:
    image: selenium/node-chrome
    depends_on:
      - selenium-hub
    environment:
      - HUB_HOST=selenium-hub
      - HUB_PORT=4444
```

### common commands
* `docker-compose -f custom.yml up -d`  specify a cusom yml file name, and start as daemon
* `docker-compose -f cutom.yml down`   stop all containers and remove them; purge everything including network
* `docker-compose up --build` will force re-create the image
* `docker-compose up --force-recreate` will force re-create container
* `docker-compose run --rm helloworld` will start the service configured in docker-compose.yml


### needs help
`docker-compose help`

`dcker-compose up --help`
Usage: up [options] [SERVICE...]

Options:
    -d                         Detached mode: Run containers in the background,
                               print new container names.
                               Incompatible with --abort-on-container-exit.
    --force-recreate           Recreate containers even if their configuration
                               and image haven't changed.
                               Incompatible with --no-recreate.
