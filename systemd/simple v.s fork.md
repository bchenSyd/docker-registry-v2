> http://patrakov.blogspot.com.au/2011/01/writing-systemd-service-files.html
## Simple services

Here is the simplest possible service file that starts my_service with options that work for me on my computer. Save it as /etc/systemd/system/my_service:
```
[Unit]
Description=Systemd Service Example

[Service]
ExecStart=/usr/bin/my_service --tap tap0 --mode 0660 \
 --dirmode 0750 --group qemu
Restart=on-abort


[Install]
WantedBy=multi-user.target
```

Note the difference from a traditional init script: for simplicity, `my_service` is started in such a way that it doesn't become a daemon. 

## fork services
To start real daemons that fork, you just have to tell systemd about that:
```
[Unit]
Description=Systemd Service Example

[Service]
Type=forking
# The PID file is optional, but recommended in the manpage
# "so that systemd can identify the main process of the daemon"
PIDFile=/var/run/my_service.pid
ExecStart=/usr/bin/my_service --tap tap0 --mode 0660 \
 --dirmode 0750 --group qemu \
 --daemon --pidfile /var/run/my_service.pid
Restart=on-abort

[Install]
WantedBy=multi-user.target
```

## difference
with `Type=forking`, you tell systemd that you are a daemon and you will fork youself;
The difference is in the way the dependencies are handled. If some other services depend on `my_service`, then, in the first example, systemd will be able to run them as soon as it starts `my_service`. In the second example, systemd will wait until `my_service` forks. The difference matters, because `my_service` creates its control socket after starting, but before forking. So, in the first example, there is some chance that systemd will start something that tries to connect to the socket before `my_service` creates it.


## restart on abort
```
# systemctl start my_service
# systemctl status my_service
        my_service - Systemd Service Example
        Loaded: loaded (/etc/systemd/system/my_service)
        Active: active (running) since Tue, 04 Jan 2011 22:08:10 +0500; 15s ago
        Process: 31434 (/usr/bin/my_service --tap tap0...,
            code=exited, status=0/SUCCESS)
        Main PID: 31435 (my_service)
        CGroup: name=systemd:/system/my_service
            └ 31435 /usr/bin/my_service --tap tap0...

# kill -SEGV 31435


# systemctl status my_service
        my_service - Systemd Service Example
        Loaded: loaded (/etc/systemd/system/my_service)
        Active: **failed****** since Tue, 04 Jan 2011 22:11:27 +0500; 4s ago
        Process: 31503 (/usr/bin/my_service --tap tap0...,
            code=exited, status=0/SUCCESS)
            Main PID: 31504 (code=exited, status=1/FAILURE)
            CGroup: name=systemd:/system/my_service
```
I.e., restarting didn't work. The system log tells us why
> https://unix.stackexchange.com/a/225407
```bash
# -u: unit name -b: see current boot only
> journalctl -u my_service.service -b
    Jan  4 22:11:27 home my_service[31504]: Error in pidfile
    creation: File exists
```

So, `my_service` has a bug in its pidfile creation. There are two ways how one can deal with this: either tell systemd to remove the PID file before starting `my_service`, or drop the PID file altogether (because `my_service` has exactly one process, there can be no confusion which process is the main one). Both ways work. 

 * ### Here is how to implement the first alternative:
```
[Unit]
Description=Systemd Service Example
After=syslog.target

[Service]
Type=forking
PIDFile=/var/run/my_service.pid
# Note the -f: don't fail if there is no PID file
ExecStartPre=/bin/rm -f /var/run/my_service.pid
ExecStart=/usr/bin/my_service --tap tap0 --mode 0660 \
 --dirmode 0750 --group qemu \
 --daemon --pidfile /var/run/my_service.pid
Restart=on-abort

[Install]
WantedBy=multi-user.target
```


* ### And here is the second alternative:
```
[Unit]
Description=Systemd Service Example
After=syslog.target

[Service]
Type=forking
ExecStart=/usr/bin/my_service --tap tap0 --mode 0660 \
 --dirmode 0750 --group qemu \
 --daemon
Restart=on-abort

[Install]
WantedBy=multi-user.target
```