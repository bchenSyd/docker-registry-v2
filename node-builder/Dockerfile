FROM ubuntu
LABEL maintainer="bochen2014@yahoo.com"

ENV http_proxy  http://proxy.yourproxy-srv.com.au:8080
ENV https_proxy http://proxy.yourproxy-srv.com.au:8080

WORKDIR /opt
RUN apt update &&\
    # install wget, curl and apt-transport-https (required by install yarn)
    apt install -y wget &&\
    apt install -y curl &&\
    apt-get install -y apt-transport-https &&\
    #install git
    apt install git -y &&\
    #install yarn
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - &&\
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list  &&\
    apt-get update && apt-get install -y  yarn &&\
    #install nodejs
    wget https://nodejs.org/download/release/v8.4.0/node-v8.4.0-linux-x64.tar.gz -O /tmp/node-v8.4.tgz &&\
    tar xfz /tmp/node-v8.4.tgz --strip-component 1 -C /usr/local &&\
    #install dumb-init
    wget -O  /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 && \
    chmod +x /usr/local/bin/dumb-init &&\
    # clean up. reduce image size
    rm -rf /var/lib/apt/lists/*

ADD ./docker-builder/BuilderScript.sh  /opt/docker-builder/BuilderScript.sh

VOLUME [ "/opt", "/source"]
WORKDIR /source

# ENTRYPOINT will append `docker run` parameters
# so here, scripts user specified will be appended to dumb-init
ENTRYPOINT [ "/usr/local/bin/dumb-init","--"]
# CMD will be overritten by `docker run` parameters
# so when user doesn't specify anything, this is what we want to run
CMD /usr/local/bin/dumb-init -- /opt/docker-builder/BuilderScript.sh
