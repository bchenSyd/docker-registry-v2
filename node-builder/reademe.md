1. build image: `docker build -t nodebuilder .`
2. update configuration
    1. `docker volume -v nodebuilder-v`
    2. copy ephemeral container's data into volume `docker --rm -v nodebuilder-v:/opt nodebuilder ls`
    3. edit `docker run --rm -it -v nodebuilder:/opt busybox`
       `vim /opt/docker-builder/BuildScript.sh`
    4. start container   
        ```
        docker run --rm \
        -e "BOCHEN_PROJECT_TYPE=APP" \
        -e "BOCHEN_PROJECT_BUILD_TYPE=npm" \
        -e "BOCHEN_BUILD_NUMBER=49" \
        -e "BOCHEN_REPOSITORY_URI=react-gel" \
        -e "BOCHEN_CURR_UID=1000" \
        -e "BOCHEN_CURR_GID=1000" \
        -v `pwd`:/source \
        -v nodebuilder-v:/opt \
        nodebuilder
        ```
