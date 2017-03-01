FROM robotology/yarp
MAINTAINER Diego Ferigo <diego.ferigo@iit.it>

# Install iCub
RUN apt-get update &&\
    apt-get install -y --no-install-recommends \
        icub &&\
    rm -rf /var/lib/apt/lists/*
