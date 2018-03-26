FROM ubuntu:xenial
MAINTAINER Diego Ferigo <diego.ferigo@iit.it>

ARG YARP_BRANCH=master
ARG YARP_BUILD_TYPE=Debug

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
EXPOSE 10000/tcp 10000/udp

# Some QT-Apps don't show controls without this
ENV QT_X11_NO_MITSHM 1

# Setup HW Acceleration for Intel graphic cards
RUN apt-get update && apt-get install -y \
        libgl1-mesa-glx \
        libgl1-mesa-dri &&\
    rm -rf /var/lib/apt/lists/*

# nvidia-docker hooks
LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV PATH /usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}
