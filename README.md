# Modified Shiny Server Binaries 

## Motivation

- Posit only provides amd64 binaries for Shiny Server, so we build both amd64 and arm64 binaries following [their instructions](https://github.com/rstudio/shiny-server/wiki/Building-Shiny-Server-from-Source).
- Provided in a docker image that you can use in your own Dockerfile via [multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/).

## Usage 

- Install directory is in `/usr/local`, so copy from there and add the binary to your path.
- This adds roughly 300MB to your container, so there might be opportunities to slim down.

```Dockerfile 
ENV PATH="$PATH:/usr/local/shiny-server/bin"
COPY --from=ghcr.io/tjpalanca/shiny-server:latest /usr/local/shiny-server /usr/local/shiny-server
COPY --from=ghcr.io/tjpalanca/shiny-server:latest /etc/shiny-server /etc/shiny-server
```