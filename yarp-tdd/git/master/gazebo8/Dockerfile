FROM robotology/yarp-gazebo:gazebo8master
MAINTAINER Diego Ferigo <diego.ferigo@iit.it>

ARG GIT_BRANCH=master
ARG BUILD_TYPE=Release

# Install build tools
RUN apt-get update &&\
    apt-get install -y --no-install-recommends \
        build-essential \
        ccache \
        llvm \
        clang \
        git \
        ninja-build \
        liblua5.3-dev \
        &&\
    rm -rf /var/lib/apt/lists/*

# Install the testing frameworks
RUN git clone https://github.com/robotology/robot-testing &&\
    cd robot-testing &&\
    git checkout $GIT_BRANCH &&\
    mkdir build && cd build &&\
    cmake -DENABLE_MIDDLEWARE_PLUGINS:BOOL=ON \
          -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
          -DENABLE_LUA_PLUGIN:BOOL=ON \
          .. &&\
    make &&\
    make install
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
RUN ldconfig

RUN git clone https://github.com/robotology/icub-tests &&\
    cd icub-tests &&\
    git checkout $GIT_BRANCH &&\
    mkdir build && cd build &&\
    cmake -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
          .. &&\
    make &&\
    make install

RUN git clone https://github.com/robotology/icub-gazebo

# Install YCM
RUN git clone https://github.com/robotology/ycm.git &&\
    cd ycm &&\
    git checkout $GIT_BRANCH &&\
    mkdir build && cd build &&\
    cmake -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
          .. &&\
    make &&\
    make install

# Set environment variables for YARP and Gazebo
ENV YARP_DATA_DIRS=${YARP_DATA_DIRS}:/icub-tests/suits
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/icub-tests/build/plugins
RUN ldconfig
ENV GAZEBO_MODEL_PATH=${GAZEBO_MODEL_PATH}:/icub-gazebo
ENV GAZEBO_RESOURCE_PATH=${GAZEBO_RESOURCE_PATH}:/icub-gazebo

# Enable ccache
ENV PATH=/usr/lib/ccache:$PATH
