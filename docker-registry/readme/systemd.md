> https://www.digitalocean.com/community/tutorials/how-to-set-up-a-private-docker-registry-on-ubuntu-14-04


*nginx as reverse proxy to handle authentication; docker-registry:5000 is the real server*

codeplane.com:80 --->  nginx reverse proxy to codeplane.com:3000  ----> ssh tunnel <=======>  localhost:3000
see [nginx ssh tunnel](https://gist.github.com/fnando/1101211)



### setup a systemd service on Ubuntu 15.04 and above

#### upstart
`service service-name command` , got abandoned in 9th Mar 2015 (Ubuntu 15.04)
> http://www.theregister.co.uk/2015/03/07/ubuntu_to_switch_to_systemd/
init is really old stuff

#### systemd
`systemctl status docker.service`
```bash
$ service docker status
Redirecting to /bin/systemctl status docker.service
● docker.service - Docker Application Container Engine
   Loaded: loaded (/usr/lib/systemd/system/docker.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2017-12-06 22:40:04 UTC; 1h 55min ago
     Docs: https://docs.docker.com
 Main PID: 843 (dockerd)
   Memory: 59.4M
   CGroup: /system.slice/docker.service
           ├─843 /usr/bin/dockerd
           └─973 docker-containerd -l unix:///var/run/docker/libcontainerd/docker-containerd.sock --metrics-interval=0
```

```bash
# default services
ls /etc/systemd/
bootchart.conf  coredump.conf  journald.conf  logind.conf  system  system.conf  user  user.conf

cd /etc/systemd/system/ # OR  /lib/systemd/system/
ln -s /opt/docker-registry/systemd/docker-registry.service   /lib/systemd/system/docker-registry.service
```
by default, docker-compose is only installed in `/usr/local/bin`, which makes it unaccessible without sudo in. 
```bash
# ln -s {source-file-name } {target-file-name}
ln -s /usr/local/bin/docker-compose   /usr/local/sbin/docker-compose
```


#### start the service 

```sh
`systemctl enable /opt/docker-registry/systemd/docker-registry.service`
Created symlink from /etc/systemd/system/multi-user.target.wants/docker-registry.service to /opt/docker-registry/systemd/docker-registry.service.
Created symlink from /etc/systemd/system/docker-registry.service to /opt/docker-registry/systemd/docker-registry.service.


`systemctl start docker-registry.service`
`systemctl status  docker-registry.service`

after change file, run `systemctl daemon-reload`

Warning: docker-registry.service changed on disk. Run 'systemctl daemon-reload' to reload units.

remove the service

`systemctl disable docker-registry.service`
Removed symlink /etc/systemd/system/docker-registry.service.
Removed symlink /etc/systemd/system/multi-user.target.wants/docker-registry.service.
```	


#### after change file,  run `systemctl daemon-reload`
Warning: docker-registry.service changed on disk. Run 'systemctl daemon-reload' to reload units.


#### remove the service

```
root@bchen:/lib/systemd/system# systemctl disable docker-registry.service
Removed symlink /etc/systemd/system/docker-registry.service.
Removed symlink /etc/systemd/system/multi-user.target.wants/docker-registry.service.
```




