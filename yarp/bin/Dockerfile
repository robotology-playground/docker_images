FROM ubuntu:xenial
MAINTAINER Diego Ferigo <diego.ferigo@iit.it>

# Install YARP
RUN echo "deb http://www.icub.org/ubuntu `lsb_release -cs` contrib/science" \
        > /etc/apt/sources.list.d/icub.list &&\
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 57A5ACB6110576A6 &&\
    apt-get update &&\
    apt-get install -y yarp &&\
    rm -rf /var/lib/apt/lists/*

# Check YARP installation
RUN yarp check

# YARP ports management
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

CMD ["bash"]
