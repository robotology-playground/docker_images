FROM robotology/yarp-gazebo:gazebo8bin
MAINTAINER Diego Ferigo <diego.ferigo@iit.it>

# Install build tools
RUN apt-get update &&\
    apt-get install -y --no-install-recommends \
        build-essential \
        git &&\
    rm -rf /var/lib/apt/lists/*

# Install the testing frameworks
RUN git clone https://github.com/robotology/robot-testing &&\
    cd robot-testing &&\
    mkdir build && cd build &&\
    cmake -DENABLE_MIDDLEWARE_PLUGINS:BOOL=ON \
          -DCMAKE_BUILD_TYPE=Release \
          .. &&\
    make &&\
    make install
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
RUN ldconfig

RUN git clone https://github.com/robotology/icub-tests &&\
    cd icub-tests &&\
    mkdir build && cd build &&\
    cmake -DENABLE_MIDDLEWARE_PLUGINS:BOOL=ON \
          -DCMAKE_BUILD_TYPE=Release \
          .. &&\
    make &&\
    make install

RUN git clone https://github.com/robotology-playground/icub-gazebo
ENV YARP_DATA_DIRS=${YARP_DATA_DIRS}:/icub-tests/suits
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/icub-tests/build/plugins
RUN ldconfig
ENV GAZEBO_MODEL_PATH=${GAZEBO_MODEL_PATH}:/icub-gazebo
ENV GAZEBO_RESOURCE_PATH=${GAZEBO_RESOURCE_PATH}:/icub-gazebo
