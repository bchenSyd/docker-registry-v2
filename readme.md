# setup a systemd service on Ubuntu 15.04 and above, or upStart below Ubuntu 15.04 
upstart
/etc/init/docker-registry.conf
systemd

cd /etc/systemd/system/  OR  /lib/systemd/system/"
ln -s /opt/docker-registry/systemd/docker-registry.service   docker-registry.service
>ln -s {target-file-name } {link-name}

after change file,  run `systemctl daemon-reload`
Warning: docker-registry.service changed on disk. Run 'systemctl daemon-reload' to reload units.


see: https://www.digitalocean.com/community/tutorials/how-to-set-up-a-private-docker-registry-on-ubuntu-14-04
# Set up authentication
sudo apt-get -y install apache2-utils
>use htpasswd to create password hash 
cd ~/docker-registry/nginx
`htpasswd -c registry.password bo`
without `-c`  ( c for create)
`htpasswd  registry.password bo`

---
bochen2014@bchen:/opt/docker-registry/nginx$ curl http://localhost:5043/v2/
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

# Signing Your Own Certificate

Since Docker currently doesn't allow you to use self-signed SSL certificates this is a bit more complicated than usual — we'll also have to set up our system to act as our own certificate signing authority.

To begin, let's change to our ~/docker-registry/nginx folder and get ready to create the certificates:

cd ~/docker-registry/nginx
Generate a new root key:

openssl genrsa -out devdockerCA.key 2048
Generate a root certificate (enter whatever you'd like at the prompts):

openssl req -x509 -new -nodes -key devdockerCA.key -days 10000 -out devdockerCA.crt
Then generate a key for your server (this is the file referenced by ssl_certificate_key in our Nginx configuration):

openssl genrsa -out domain.key 2048
Now we have to make a certificate signing request.

After you type this command, OpenSSL will prompt you to answer a few questions. Write whatever you'd like for the first few, but when OpenSSL prompts you to enter the "Common Name" make sure to type in the domain or IP of your server.

openssl req -new -key domain.key -out dev-docker-registry.com.csr
For example, if your Docker registry is going to be running on the domain www.ilovedocker.com, then your input should look like this:

Country Name (2 letter code) [AU]:
State or Province Name (full name) [Some-State]:
Locality Name (eg, city) []:
Organization Name (eg, company) [Internet Widgits Pty Ltd]:
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:www.ilovedocker.com
Email Address []:

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
Do not enter a challenge password.

Next, we need to sign the certificate request:

openssl x509 -req -in dev-docker-registry.com.csr -CA devdockerCA.crt -CAkey devdockerCA.key -CAcreateserial -out domain.crt -days 10000
Since the certificates we just generated aren't verified by any known certificate authority (e.g., VeriSign), we need to tell any clients that are going to be using this Docker registry that this is a legitimate certificate. Let's do this locally on the host machine so that we can use Docker from the Docker registry server itself:

sudo mkdir /usr/local/share/ca-certificates/docker-dev-cert
sudo cp devdockerCA.crt /usr/local/share/ca-certificates/docker-dev-cert
sudo update-ca-certificates
Restart the Docker daemon so that it picks up the changes to our certificate store:

sudo service docker restart
Warning: You'll have to repeat this step for every machine that connects to this Docker registry! Instructions for how to do this for Ubuntu 14.04 clients are listed in Step 9 — Accessing Your Docker Registry from a Client Machine.
