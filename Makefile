# Platform 

PLATFORM ?= $(shell docker version --format '{{.Server.Os}}/{{.Server.Arch}}')

# Project

# Check https://github.com/rstudio/shiny-server for version
VERSION = "v1.5.23.1030"
# Since modifying shiny server, should license as AGPL-3.0-or-later
LICENSE = "AGPL-3.0-or-later" 

# Shiny Server

SERVER_IMG=ghcr.io/tjpalanca/shiny-server
SERVER_TAG=$(SERVER_IMG):$(VERSION)
SERVER_BUILD_ARGS=\
	--file Dockerfile \
	--platform $(PLATFORM) \
	--label "org.opencontainers.image.source=$(REPO_URL)" \
	--label "org.opencontainers.image.licenses=$(LICENSE)" \
	--tag $(SERVER_TAG) \
	--tag $(SERVER_IMG):latest 

server-publish:
	docker buildx build \
		$(SERVER_BUILD_ARGS) \
		--cache-to=type=registry,ref=$(SERVER_IMG):cache,mode=max \
		--cache-from=type=registry,ref=$(SERVER_IMG):cache \
		--push . 

server-build:
	docker build $(SERVER_BUILD_ARGS) .

server-push: 
	docker push $(SERVER_TAG) && docker push $(SERVER_IMG):latest

server-run: server-build
	docker run -it \
		-p 3838:3838 \
		$(SERVER_TAG)

server-bash: server-build
	docker run -it $(SERVER_TAG) /bin/bash
