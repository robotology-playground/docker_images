FROM ubuntu:xenial
MAINTAINER Diego Ferigo <diego.ferigo@iit.it>

ARG YARP_BRANCH=devel
ARG YARP_BUILD_TYPE=Release

# Install useful packages
RUN apt-get update && apt-get install -y \
        build-essential \
        git \
		  cmake &&\
    rm -rf /var/lib/apt/lists/*

# Install libraries
RUN apt-get update &&\
    apt-get install -y \
        libgsl-dev \
        libedit-dev \
        libace-dev \
		  libeigen3-dev &&\
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/robotology/yarp.git &&\
    cd yarp &&\
    git checkout $YARP_BRANCH &&\
    mkdir build && cd build &&\
    cmake -DCMAKE_BUILD_TYPE=$YARP_BUILD_TYPE \
          -DCREATE_LIB_MATH=ON \
          .. &&\
    make install &&\
    cd / &&\
    rm -r /yarp

RUN yarp check
EXPOSE 10000/tcp
