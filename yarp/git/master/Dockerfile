FROM ubuntu:xenial
MAINTAINER Diego Ferigo <diego.ferigo@iit.it>

RUN apt-get update

FROM ubuntu:xenial
COPY --from=0 /var/lib/apt/lists/* /var/lib/apt/lists/

ARG YARP_BRANCH=master
ARG YARP_BUILD_TYPE=Debug

# Install useful packages
RUN apt-get install -y \
        build-essential \
        git \
        cmake \
        lsb-release

# Install libraries
RUN apt-get install -y \
        libgsl-dev \
        libedit-dev \
        libace-dev \
        libeigen3-dev

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
RUN apt-get install -y \
        libgl1-mesa-glx \
        libgl1-mesa-dri

# nvidia-docker hooks
LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV PATH /usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

# Clean the image
RUN rm -r /var/lib/apt/lists/*
