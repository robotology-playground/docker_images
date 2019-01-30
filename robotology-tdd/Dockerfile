ARG BASE_IMAGE=ubuntu:bionic
FROM ${BASE_IMAGE}
MAINTAINER Diego Ferigo <diego.ferigo@iit.it>

ARG GAZEBO_VER=9
ARG BRANCH=master
ARG BUILD_TYPE=Debug
ARG CMAKE_GENERATOR="Unix Makefiles"
ARG CMAKE_EXTRA_OPTIONS=-j2

RUN apt-get update &&\
    apt-get install -y \
        lsb-release \
        wget \
        gnupg \
        git \
        build-essential \
        cmake \
        ninja-build \
        clang \
        ccache \
        valgrind \
        &&\
    rm -rf /var/lib/apt/lists/*

# Get gazebo from the osrf repo
RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" \
        > /etc/apt/sources.list.d/gazebo-stable.list &&\
    wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add - &&\
    apt-get update &&\
    apt-get install --no-install-recommends -y \
        gazebo${GAZEBO_VER} \
        libgazebo${GAZEBO_VER}-dev \
        &&\
    rm -rf /var/lib/apt/lists/*

# Install dependencies for the git projects
RUN apt-get update &&\
    apt-get install -y \
        # MISC
        qt5-default \
        # YARP
        libace-dev \
        libeigen3-dev \
        libgsl-dev \
        libedit-dev \
        libqcustomplot-dev \
        qtmultimedia5-dev \
        qtdeclarative5-dev \
        libqt5opengl5-dev \
        qttools5-dev \
        # GAZEBO-YARP-PLUGINS
        libatlas-base-dev \
        # IDYNTREE
        coinor-libipopt-dev \
        # MISC
        libasio-dev \
        libmatio-dev \
        &&\
    rm -rf /var/lib/apt/lists/*

ARG PROJECTS_DIR=/projects

# Setup entrypoint
ARG ROBOTOLOGY_INITIALIZATION_FILE=/usr/local/bin/setup_robotology_tdd.sh
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY setup.sh ${ROBOTOLOGY_INITIALIZATION_FILE}
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

# Install the projects using the superbuild
RUN mkdir ${PROJECTS_DIR} && cd ${PROJECTS_DIR} &&\
    git clone https://github.com/robotology/robotology-superbuild.git &&\
    cd robotology-superbuild &&\
    mkdir build && cd build &&\
    cmake .. \
        -G "$CMAKE_GENERATOR" \
        -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
        -DNON_INTERACTIVE_BUILD:BOOL=ON \
        -DROBOTOLOGY_ENABLE_CORE:BOOL=ON \
        -DROBOTOLOGY_ENABLE_DYNAMICS:BOOL=ON \
        -DROBOTOLOGY_USES_GAZEBO:BOOL=ON \
        -DYCM_USE_DEPRECATED:BOOL=OFF \
        # Select the tag for the shipped projects
        -DYARP_TAG=${BRANCH} \
        -DYCM_TAG=${BRANCH} \
        -DRTF_TAG=${BRANCH} \
        -DiDynTree_TAG=${BRANCH} \
        -DICUB_TAG=${BRANCH} \
        -DGazeboYARPPlugins_TAG=${BRANCH} \
        -Dcodyco-modules_TAG=${BRANCH} \
        -Dicub-tests_TAG=${BRANCH} \
        -DWBToolbox_TAG=${BRANCH} \
        &&\
    # Build all the projects
    cmake --build . --target update-all -- -j4 &&\
    cmake --build . -- ${CMAKE_EXTRA_OPTIONS} &&\
    echo "source ${PROJECTS_DIR}/robotology-superbuild/build/install/share/robotology-superbuild/setup.sh" >> $ROBOTOLOGY_INITIALIZATION_FILE

# Waiting https://github.com/robotology/robotology-superbuild/issues/95
RUN echo 'export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${ROBOTOLOGY_SUPERBUILD_INSTALL_PREFIX}/lib/rtf'  >> $ROBOTOLOGY_INITIALIZATION_FILE

# The bashrc is read only when opening an interactive shell. Let other projects find packages contained
# in the superbuild.
ENV CMAKE_PREFIX_PATH=${PROJECTS_DIR}/robotology-superbuild/build/install

# Enable CCACHE by default
ENV PATH=/usr/lib/ccache:$PATH
RUN mkdir $HOME/.ccache &&\
    echo "max_size = 2.0G" > $HOME/.ccache/ccache.conf
