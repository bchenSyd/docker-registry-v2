## compose file reference
> https://docs.docker.com/compose/compose-file/
> http://docs.octopusdeploy.com/display/OD/Node+on+*Nix+deployments


## docker-compose force rebuild / re-create container

* `docker-compose -f custom.yml up`  specify a cusom yml file name
* `docker-compose up --build` will force re-create the image
* `docker-compose up --force-recreate` will force re-create container
* `docker-compose run --rm helloworld` will start the service configured in docker-compose.yml

## add docker-compose to usr/local/sbin  (sbin: require root previledge)
```
[root@ip-10-77-20-253 ~]# docker-compose
-bash: docker-compose: command not found
[root@ip-10-77-20-253 ~]# which docker-compose
/usr/bin/which: no docker-compose in (/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin)
[root@ip-10-77-20-253 ~]# exit
logout
[bo.chen@ip-10-77-20-253 ~]$ which docker-compose
/usr/local/bin/docker-compose
[bo.chen@ip-10-77-20-253 ~]$ ln -s /usr/local/bin/docker-compose  /usr/local/sbin/docker-compose
ln: failed to create symbolic link ‘/usr/local/sbin/docker-compose’: Permission denied
[bo.chen@ip-10-77-20-253 ~]$ sudo ln -s /usr/local/bin/docker-compose  /usr/local/sbin/docker-compose
[bo.chen@ip-10-77-20-253 ~]$ sudo -i
[root@ip-10-77-20-253 ~]# which docker-compose
/usr/local/sbin/docker-compose
[root@ip-10-77-20-253 ~]# docker-compose
Define and run multi-container applications with Docker.

Usage:
  docker-compose [-f <arg>...] [options] [COMMAND] [ARGS...]
  docker-compose -h|--help

Options:
  -f, --file FILE             Specify an alternate compose file (default: docker-compose.yml)
  -p, --project-name NAME     Specify an alternate project name (default: directory name)
  --verbose                   Show more output
  -v, --version               Print version and exit
  -H, --host HOST             Daemon socket to connect to
  
  
  
  
  
  
  
  dcker-compose up --help
  If you want to force Compose to stop and recreate all containers, use the
`--force-recreate` flag.

Usage: up [options] [SERVICE...]

Options:
    -d                         Detached mode: Run containers in the background,
                               print new container names.
                               Incompatible with --abort-on-container-exit.
    --no-color                 Produce monochrome output.
    --no-deps                  Don't start linked services.
    --force-recreate           Recreate containers even if their configuration
                               and image haven't changed.
                               Incompatible with --no-recreate.
    --no-recreate              If containers already exist, don't recreate them.
                               Incompatible with --force-recreate.
    --no-build                 Don't build an image, even if it's missing.
    --build                    Build images before starting containers.
    --abort-on-container-exit  Stops all containers if any container was stopped.
                               Incompatible with -d.
    -t, --timeout TIMEOUT      Use this timeout in seconds for container shutdown
                               when attached or when containers are already
                               running. (default: 10)
    --remove-orphans           Remove containers for services not
                               defined in the Compose file
  
```
