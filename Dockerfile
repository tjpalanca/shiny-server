# Instructions: https://github.com/rstudio/shiny-server/wiki/Building-Shiny-Server-from-Source
FROM python:3.12-bookworm

# Linux dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      build-essential cmake && \
    rm -rf /var/lib/apt/lists/*

# Clone the repository from GitHub
ARG VERSION
RUN git clone --depth 1 --branch ${VERSION} https://github.com/rstudio/shiny-server.git

# Install node
COPY shims/sockjs.js /shiny-server/lib/proxy/sockjs.js
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
COPY shims/transport.js /shiny-server/node_modules/sockjs/lib/transport.js
RUN make install
RUN rm -rf /shiny-server

# Set up demo app
RUN pip install shiny 
RUN useradd -u 1000 -m shiny
ENV PATH="$PATH:/usr/local/shiny-server/bin"
ENV SHINY_LOG_STDERR=1
RUN mkdir -p /etc/shiny-server
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf
RUN mkdir -p /var/lib/shiny-server/bookmarks && chown shiny /var/lib/shiny-server/bookmarks
RUN mkdir -p /var/log/shiny-server && chown shiny /var/log/shiny-server
COPY app /app

# Run demo app
USER shiny
EXPOSE 3838
CMD ["shiny-server"]

