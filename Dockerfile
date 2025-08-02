FROM buildpack-deps:bookworm AS builder

# Linux dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      build-essential cmake && \
    rm -rf /var/lib/apt/lists/*

# Clone the repository from GitHub
RUN git clone --depth 1 --branch v1.5.23.1030 https://github.com/rstudio/shiny-server.git
# Install node
WORKDIR /shiny-server 
RUN mkdir tmp 
WORKDIR /shiny-server/tmp
RUN ../external/node/install-node.sh
ENV PATH="/shiny-server/bin:$PATH"

# Prepare, build, and install
RUN cmake -DCMAKE_INSTALL_PREFIX=/usr/local /shiny-server
RUN make
RUN mkdir /shiny-server/build
RUN /shiny-server/bin/npm ci --omit-dev
RUN make install

# Configuration file 
RUN mkdir -p /etc/shiny-server
RUN cp ../config/default.config /etc/shiny-server/shiny-server.conf