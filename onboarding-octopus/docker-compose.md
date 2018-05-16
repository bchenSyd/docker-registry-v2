## compose file reference
> https://docs.docker.com/compose/compose-file/
> http://docs.octopusdeploy.com/display/OD/Node+on+*Nix+deployments


## docker-compose force rebuild / re-create container

* `docker-compose -f custom.yml up`  specify a cusom yml file name
* `docker-compose up --build` will force re-create the image
* `docker-compose up --force-recreate` will force re-create container
* `docker-compose run --rm helloworld` will start the service configured in docker-compose.yml

## add docker-compose to usr/local/sbin  (sbin: require root previledge)
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
