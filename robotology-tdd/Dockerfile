ARG BASE_IMAGE=ubuntu:focal
FROM ${BASE_IMAGE}
MAINTAINER Diego Ferigo <diego.ferigo@iit.it>

ARG GAZEBO_VER=11
ARG BUILD_TYPE=Debug
ARG PROJECT_TAGS="Stable"
ARG CMAKE_GENERATOR="Ninja"

RUN apt-get update &&\
    apt-get install -y apt-transport-https ca-certificates gnupg software-properties-common wget &&\
    rm -rf /var/lib/apt/lists/*

ARG TZ=Europe/Rome
ARG DEBIAN_FRONTEND=noninteractive
RUN rm -f /etc/localtime &&\
    ln -s /usr/share/zoneinfo/"${TZ}" /etc/localtime &&\
    apt-get update &&\
    apt-get install -y --no-install-recommends locales locales-all tzdata &&\
    rm -rf /var/lib/apt/lists/*

RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | apt-key add - && \
    apt-add-repository "deb https://apt.kitware.com/ubuntu/ `lsb_release -cs` main" &&\
    apt-get install -y kitware-archive-keyring &&\
    apt-key --keyring /etc/apt/trusted.gpg del C1F34CDD40CD72DA &&\
    apt-get update &&\
    apt-get install -y \
        lsb-release \
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
        libxml2-dev \
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
        -G "${CMAKE_GENERATOR}" \
        -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
        -DROBOTOLOGY_PROJECT_TAGS=${PROJECT_TAGS} \
        -DROBOTOLOGY_ENABLE_DYNAMICS:BOOL=ON \
        -DROBOTOLOGY_USES_GAZEBO:BOOL=ON \
        -DNON_INTERACTIVE_BUILD:BOOL=ON \
        &&\
    # Build all the projects
    cmake --build . --target update-all &&\
    cmake --build . &&\
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
