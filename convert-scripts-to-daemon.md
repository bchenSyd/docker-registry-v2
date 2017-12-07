replace <strong>program name</strong> with your program name

```bash
#!/bin/sh -e

# Daemon name:  your program name
# Description: Starts program as a daemon process


case "$1" in
  start)
    LOGFILE=/var/log/<strong>program</strong>.log
    touch $LOGFILE
    chown daemon $LOGFILE
    export <strong>PROGRAM_HOME</strong>=/usr/local/<strong>program</strong>
    cd $<strong>PROGRAM_HOME</strong>/bin
    sudo -Enu daemon sh -c "./<strong>program </strong>&gt;$LOGFILE 2&gt;&amp;1 &amp;"
    ;;

  stop)
    killall -INT <strong>program</strong>
    ;;

  restart|force-reload)
    $0 stop
    $0 start
    ;;

  *)
    echo "Usage: $0 {start|stop|restart|force-reload}" &gt;&amp;2
    exit 1
    ;;
esac
```
