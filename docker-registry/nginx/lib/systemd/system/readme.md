[Compiling and Installing from Source](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/#compiling-and-installing-from-source)
1. `cd /opt`
2. download `pcrc` and `zlib` source
`wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.41.tar.gz`
`tar -xzf pcre-8.41.tar.gz`

`wget http://zlib.net/zlib-1.2.11.tar.gz`
`tar -zxf zlib-1.2.11.tar.gz`

`wget http://www.openssl.org/source/openssl-1.0.2k.tar.gz`
`tar -zxf openssl-1.0.2k.tar.gz`
3. dowload `nginx` source
`wget http://nginx.org/download/nginx-1.13.4.tar.gz`
`tar zxf nginx-1.13.4.tar.gz`
`cd nginx-1.13.4`
4. `sudo ./cofnig --with-stream  --with-pcre=../pcre-8.41 --with-zlib=../zlib-1.2.11`
   `make`
   `sudo make install`
5. `sudo vim /lib/systemd/system/nginx.service`
    and paste `./nginx.service` there
6. `sudo systemctl nginx start`


```
  nginx path prefix: "/usr/local/nginx"
  nginx binary file: "/usr/local/nginx/sbin/nginx"
  nginx modules path: "/usr/local/nginx/modules"
  nginx configuration prefix: "/usr/local/nginx/conf"
  nginx configuration file: "/usr/local/nginx/conf/nginx.conf"
  nginx pid file: "/usr/local/nginx/logs/nginx.pid"
  nginx error log file: "/usr/local/nginx/logs/error.log"
  nginx http access log file: "/usr/local/nginx/logs/access.log"
  nginx http client request body temporary files: "client_body_temp"
  nginx http proxy temporary files: "proxy_temp"
  nginx http fastcgi temporary files: "fastcgi_temp"
  nginx http uwsgi temporary files: "uwsgi_temp"
  nginx http scgi temporary files: "scgi_temp" 
```