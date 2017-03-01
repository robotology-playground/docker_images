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

# Concurrent compilation jobs
ENV GCC_JOBS=4

# Install useful tools
RUN apt-get update &&\
    apt-get install -y --no-install-recommends \
        git \
		  cmake &&\
    rm -rf /var/lib/apt/lists/*

# Install yarp-gazebo-plugin
RUN git clone https://github.com/robotology/gazebo-yarp-plugins.git &&\
    cd gazebo-yarp-plugins &&\
    mkdir build && cd build &&\
    cmake .. &&\
    make -j ${GCC_JOBS} install &&\
	 cd ../.. &&\
	 rm -r gazebo-yarp-plugins
