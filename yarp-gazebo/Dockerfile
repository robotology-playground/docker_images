FROM robotology/yarp
MAINTAINER Diego Ferigo <diego.ferigo@iit.it>

# Install gazebo8
RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable xenial main" \
        > /etc/apt/sources.list.d/gazebo-stable.list &&\
    wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add - &&\
    apt-get update &&\
    apt-get install -y --no-install-recommends \
        gazebo8 \
        gazebo8-plugin-base \
        libgazebo8-dev &&\
    rm -rf /var/lib/apt/lists/*
