FROM google/cloud-sdk

# Base image for the game type builder. Has thrift, go, docker, and gcloud installed

# apt-get all the things
RUN apt-get update
RUN apt-get -y install curl \
    libboost-dev \
    libboost-test-dev \
    libboost-program-options-dev \
    libevent-dev \
    automake \
    libtool \
    cmake \
    flex \
    bison \
    pkg-config \
    g++ \
    libssl-dev \
    apt-transport-https \
    ca-certificates \
    lxc \
    iptables

# get and install thrift
RUN wget -O thrift-0.9.3.tar.gz http://apache.claz.org/thrift/0.9.3/thrift-0.9.3.tar.gz
RUN tar -xvf thrift-0.9.3.tar.gz
RUN cd thrift-0.9.3
WORKDIR thrift-0.9.3
RUN ./configure
RUN make
RUN make install
RUN thrift -version
WORKDIR /
RUN rm -rf thrift-0.9.3 thrift-0.9.3.tar.gz

# install golang
RUN curl -O https://storage.googleapis.com/golang/go1.6.2.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.6.2.linux-amd64.tar.gz
RUN rm -rf go1.6.2.linux-amd64.tar.gz
RUN mkdir /go
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

# install docker
RUN curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-1.11.1.tgz && tar --strip-components=1 -xvzf docker-1.11.1.tgz -C /usr/local/bin

VOLUME /var/run/
