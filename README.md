# Modified Shiny Server Binaries 

## Motivation

- Posit only provides amd64 binaries for Shiny Server, so we build both amd64 and arm64 binaries following [their instructions](https://github.com/rstudio/shiny-server/wiki/Building-Shiny-Server-from-Source)
- Create shims based on this article: [Retrieving all request headers in Shiny web applications](https://marian-caikovski.medium.com/retrieving-all-request-headers-in-shiny-web-applications-dc07b79c4a7f)
- Provided in a docker image that you can use in your own Dockerfile via [multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/).

## Usage 

- Install directory is in `/usr/local`, so copy from there and add the binary to your path.
- This adds roughly 300MB to your container, so there might be opportunities to slim down.

```Dockerfile 
# Add {shiny-server}
ENV PATH="$PATH:/usr/local/shiny-server/bin" 
ENV SHINY_LOG_STDERR=1
COPY --from=ghcr.io/tjpalanca/shiny-server:latest /usr/local/shiny-server /usr/local/shiny-server
RUN mkdir -p /var/lib/shiny-server/bookmarks && chown tjbots /var/lib/shiny-server/bookmarks
RUN mkdir -p /var/log/shiny-server && chown tjbots /var/log/shiny-server
# Add configuration
RUN mkdir -p /etc/shiny-server 
COPY shiny-server.conf /etc/shiny-server 
```