> https://www.digitalocean.com/community/tutorials/how-to-set-up-a-private-docker-registry-on-ubuntu-14-04


*nginx as reverse proxy to handle authentication; registry:2 as the real docker registry server*

### setup a systemd service on Ubuntu 15.04 and above
* #### upstart ( too old. deprecated )
```
/etc/init/docker-registry.conf
```
* #### systemd

`service docker status` is just a syntax sugar to `systemctl status docker.service`
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


```
root@bchen:/lib/systemd/system# systemctl enable /opt/docker-registry/systemd/docker-registry.service
Created symlink from /etc/systemd/system/multi-user.target.wants/docker-registry.service to /opt/docker-registry/systemd/docker-registry.service.
Created symlink from /etc/systemd/system/docker-registry.service to /opt/docker-registry/systemd/docker-registry.service.


root@bchen:/lib/systemd/system# systemctl start docker-registry.service
root@bchen:/lib/systemd/system# systemctl status  docker-registry.service

```

#### after change file,  run `systemctl daemon-reload`
Warning: docker-registry.service changed on disk. Run 'systemctl daemon-reload' to reload units.


#### remove the service

```
root@bchen:/lib/systemd/system# systemctl disable docker-registry.service
Removed symlink /etc/systemd/system/docker-registry.service.
Removed symlink /etc/systemd/system/multi-user.target.wants/docker-registry.service.
```



### Registry Server: Set up authentication

#### Create User
`sudo apt-get -y install apache2-utils`
>use htpasswd to create password hash 

1. `cd ~/docker-registry/nginx`
2. `htpasswd -c registry.password bo` 
3. `htpasswd  registry.password bo` to check (without `-c` , c for create)

```
>  curl http://localhost:5043/v2/
<html>
<head><title>401 Authorization Required</title></head>
<body bgcolor="white">
<center><h1>401 Authorization Required</h1></center>
<hr><center>nginx/1.9.15</center>
</body>
</html>
bochen2014@bchen:/opt/docker-registry/nginx$ curl http://bo:bo@localhost:5043/v2/
{}
bochen2014@bchen:/opt/docker-registry/nginx$ 
```

#### Signing Your Own Certificate

Since Docker currently doesn't allow you to use self-signed SSL certificates this is a bit more complicated than usual — we'll also have to set up our system to act as our own certificate signing authority.

1. To begin, let's change to our `~/docker-registry/nginx` folder and get ready to create the certificates:
  1. `cd ~/docker-registry/nginx`
  2. Generate a new root key: `openssl genrsa -out devdockerCA.key 2048`
  3. Generate a root certificate (enter whatever you'd like at the prompts):  
  `openssl req -x509 -new -nodes -key devdockerCA.key -days 10000 -out devdockerCA.crt`
  4. Then generate a key for your server (this is the file referenced by `ssl_certificate_key` in `/ect/nginx/config.d/registry.conf`):
  `openssl genrsa -out domain.key 2048`

2.  Now we have to make a certificate signing request.

`openssl req -new -key domain.key -out dev-docker-registry.com.csr`
After you type this command, OpenSSL will prompt you to answer a few questions. Write whatever you'd like for the first few, but when OpenSSL prompts you to enter the "Common Name" make sure to type in the domain or IP of your server.

For example, if your Docker registry is going to be running on the domain `www.example.com`, then your input should look like this:
```
Country Name (2 letter code) [AU]:
State or Province Name (full name) [Some-State]:
Locality Name (eg, city) []:
Organization Name (eg, company) [Internet Widgits Pty Ltd]:
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:www.example.com
Email Address []:

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
Do not enter a challenge password.
```

Next, we need to sign the certificate request:
`openssl x509 -req -in dev-docker-registry.com.csr -CA devdockerCA.crt -CAkey devdockerCA.key -CAcreateserial -out domain.crt -days 10000`



#### Registry Client (docker daemon): Trust the certicifcate

Since the certificates we just generated aren't verified by any known certificate authority (e.g., VeriSign), we need to tell any clients that are going to be using this Docker registry that this is a legitimate certificate. Let's do this locally on the host machine so that we can use Docker from the Docker registry server itself:
```bash
sudo mkdir /usr/local/share/ca-certificates/docker-dev-cert
sudo cp devdockerCA.crt /usr/local/share/ca-certificates/docker-dev-cert
sudo update-ca-certificates
```
Restart the Docker daemon so that it picks up the changes to our certificate store:
`sudo service docker restart`

>Warning: You'll have to repeat this step for every machine that connects to this Docker registry! Instructions for how to do this for Ubuntu 14.04 clients are listed in Step 9 — Accessing Your Docker Registry from a Client Machine.

e.g on CentOS (tested on centOS 7.2)
1. Install the ca-certificates package:
`yum install ca-certificates`
2. Enable the dynamic CA configuration feature:
`update-ca-trust force-enable`
3. Add it as a new file to `/etc/pki/ca-trust/source/anchors/`  
  3.1 `cp foo.crt /etc/pki/ca-trust/source/anchors/`   
  3.2 `sudo update-ca-trust`  to update ca trust list    
  3.3 `sudo service docker restart`
