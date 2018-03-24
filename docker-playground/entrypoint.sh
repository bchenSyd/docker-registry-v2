#!/bin/sh
chown -R verdaccio:verdaccio /verdaccio 
# https://unix.stackexchange.com/a/39376/272227
# cat /etc/passwd to see the default sh
# if /bin/false, then the user is not allowed to login
su verdaccio -s /bin/sh -c 'touch /verdaccio/conf/htpasswd'