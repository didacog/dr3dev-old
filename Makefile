#.PHONY: all
#all: bin dotfiles etc ## Installs the bin and etc directory files and the dotfiles.

#arg := $(word 3, $(MAKECMDGOALS) )
ifndef editor
	editor = all
endif

ifndef tls
	tls = true
endif

.PHONY: build-godev
build-godev: build-godev-nvim build-godev-vscode build-godev-all # Builds Development Environment specified by editor=[nvim|vscode]

.PHONY: build-godev-nvim
build-godev-nvim: # Builds [neovim] Development Environment
ifeq ($(editor),nvim)
	@echo "Building godev [neovim] Environment container image ..."
	DOCKER_BUILDKIT=1 docker build --build-arg MYUSER=$(shell id -un) --build-arg MYUID=$(shell id -u) --build-arg MYGID=$(shell id -g) --build-arg DOCKERGID=$(shell cat /etc/group | grep docker | cut -d: -f3) --build-arg DR3DEV=$(PWD) -t godev:1.11.5 ./docker/godev/nvim/
endif

.PHONY: build-godev-vscode
build-godev-vscode: # Builds [vscode] Development Environment
ifeq ($(editor),vscode)
	@echo "Building godev [vscode] Environment container image ..."
	DOCKER_BUILDKIT=1 docker build --build-arg MYUSER=$(shell id -un) --build-arg MYUID=$(shell id -u) --build-arg MYGID=$(shell id -g) --build-arg DOCKERGID=$(shell cat /etc/group | grep docker | cut -d: -f3) --build-arg DR3DEV=$(PWD) -t godev-vscode:1.11.5 ./docker/godev/vscode/
endif

.PHONY: build-godev-all
build-godev-all: # Builds [complete] Development Environment
ifeq ($(editor),all)
	@echo "Building godev [complete] Environment container image ..."
	DOCKER_BUILDKIT=1 docker build --build-arg MYUSER=$(shell id -un) --build-arg MYUID=$(shell id -u) --build-arg MYGID=$(shell id -g) --build-arg DOCKERGID=$(shell cat /etc/group | grep docker | cut -d: -f3) --build-arg DR3DEV=$(PWD) -t godev-all:1.11.5 ./docker/godev/
endif

.PHONY: build-backend
build-backend: # Builds Backend images with correct UID/GIDs for Development Environment
	@echo "Building MariaDB container image ..."
	DOCKER_BUILDKIT=1 docker build --build-arg MYUID=$(shell id -u) --build-arg MYGID=$(shell id -g) -t mydb:10.3 ./docker/backend/db/
	@echo "Building Minio container image ..."
	DOCKER_BUILDKIT=1 docker build --build-arg MYUSER=$(shell id -un) --build-arg MYUID=$(shell id -u) --build-arg MYGID=$(shell id -g) -t myminio:latest ./docker/backend/minio/

.PHONY: build-tls
build-tls: # Builds CFSSL image with correct UID/GIDs for Development Environment
	@echo "Building CFSSL container image ..."
	DOCKER_BUILDKIT=1 docker build --build-arg MYUID=$(shell id -u) --build-arg MYGID=$(shell id -g) -t mytls:latest ./docker/tls/

.PHONY: build-net
build-net: # Build all required docker networks
	@echo "Setting up dr3dev docker network ..."
	docker network create --attachable dr3dev || true

.PHONY: build-all
build-all: build-net build-tls build-backend build-godev ## Build all docker images

.PHONY: start-godev
start-godev: start-godev-nvim start-godev-vscode start-godev-all ## Start [$editor] Development Environment

.PHONY: start-godev-nvim
start-godev-nvim: # Start [neovim] Development Environment
ifeq ($(editor),nvim)
ifeq ($(tls),true)
	mkdir -vp files/tls/godev
	files/tls/sh/gencert.sh godev
endif
	@echo "Starting [neovim] Development Environemnt ..."
	mkdir -vp files/golang/gopath
ifdef ghuser
	echo "$(ghuser)" > files/golang/gopath/dr3env.ghuser
endif
ifdef gitname
	echo "$(gitname)" > files/golang/gopath/dr3env.gitname
endif
ifdef gitmail
	echo "$(gitmail)" > files/golang/gopath/dr3env.gitmail
endif
	mkdir -vp files/golang/goroot
	mkdir -vp files/golang/protoc
	mkdir -vp files/vimplug
	docker-compose -f docker/godev/nvim/docker-compose.yml run godev
endif

.PHONY: start-godev-vscode
start-godev-vscode: # Start [vscode] Development Environment
ifeq ($(editor),vscode)
ifeq ($(tls),true)
	mkdir -vp files/tls/godev
	files/tls/sh/gencert.sh godev
endif
	@echo "Starting [vscode] Development Environemnt ..."
	mkdir -vp files/golang/gopath
ifdef ghuser
	echo "$(ghuser)" > files/golang/gopath/dr3env.ghuser
endif
ifdef gitname
	echo "$(gitname)" > files/golang/gopath/dr3env.gitname
endif
ifdef gitmail
	echo "$(gitmail)" > files/golang/gopath/dr3env.gitmail
endif
	mkdir -vp files/golang/goroot
	mkdir -vp files/golang/protoc
	mkdir -vp files/vscode
	docker-compose -f docker/godev/vscode/docker-compose.yml run godev
endif

.PHONY: start-godev-all
start-godev-all: # Start [complete] Development Environment
ifeq ($(editor),all)
ifeq ($(tls),true)
	mkdir -vp files/tls/godev
	files/tls/sh/gencert.sh godev
endif
	@echo "Starting [complete] Development Environemnt ..."
	mkdir -vp files/golang/gopath
ifdef ghuser
	echo "$(ghuser)" > files/golang/gopath/dr3env.ghuser
endif
ifdef gitname
	echo "$(gitname)" > files/golang/gopath/dr3env.gitname
endif
ifdef gitmail
	echo "$(gitmail)" > files/golang/gopath/dr3env.gitmail
endif
	mkdir -vp files/golang/goroot
	mkdir -vp files/golang/protoc
	mkdir -vp files/vimplug
	mkdir -vp files/vscode
	mkdir -vp files/node
	docker-compose -f docker/godev/docker-compose.yml run godev
endif

.PHONY: start-tls
start-tls: # Start CFSSL service (TLS)
ifeq ($(tls),true)
	@echo "Starting CFSSL service ..."
	mkdir -vp files/tls/ca
	docker-compose -f docker/tls/docker-compose.yml up -d
endif

.PHONY: stop-tls
stop-tls: # Stop CFSSL service (TLS)
	@echo "Stopping CFSSL service ..."
	docker-compose -f docker/tls/docker-compose.yml down

.PHONY: stop-godev
stop-godev: stop-godev-nvim stop-godev-vscode stop-godev-all ## Stop [$editor] Development Environment

.PHONY: stop-godev-nvim
stop-godev-nvim: # Stop [neovim] Development Environment
ifeq ($(editor),nvim)
	@echo "Stopping [neovim] Development Environemnt ..."
	docker-compose -f docker/godev/nvim/docker-compose.yml stop godev
endif

.PHONY: stop-godev-vscode
stop-godev-vscode: # Stop [vscode] Development Environment
ifeq ($(editor),vscode)
	@echo "Stopping [vscode] Development Environemnt ..."
	docker-compose -f docker/godev/vscode/docker-compose.yml stop godev
endif

.PHONY: stop-godev-all
stop-godev-all: # Stop [complete] Development Environment
ifeq ($(editor),all)
	@echo "Stopping [complete] Development Environemnt ..."
	docker-compose -f docker/godev/docker-compose.yml stop godev
endif

.PHONY: start-backend
start-backend: # Start Minio and MariaDB services
	@echo "Starting Minio and MariaDB ..."
	mkdir -vp files/db/data
	mkdir -vp files/minio/data
ifeq ($(tls),true)
	mkdir -vp files/tls/{mariadb,minio}
	files/tls/sh/gencert.sh mariadb
	files/tls/sh/gencert.sh minio
	docker-compose -f docker/backend/dc-withTLS.yml up -d
else
	docker-compose -f docker/backend/dc-simple.yml up -d
endif

.PHONY: stop-backend
stop-backend: # Start Minio and MariaDB services
	@echo "Stopping Minio and MariaDB ..."
	docker-compose -f docker/backend/dc-simple.yml down
	docker-compose -f docker/backend/dc-withTLS.yml down

.PHONY: start-all
start-all: start-tls start-backend start-godev ## Start complete Development Environment

.PHONY: stop-all
stop-all: stop-tls stop-backend stop-godev ## Stop complete Development Environment

.PHONY: clean-godev
clean-godev: # Clean Golang, Vim plugin and VScode files
	@echo "Cleaning up Go dev env (golang and vim plugins) ..."
	sudo rm -rvf files/golang
	rm -rvf files/vimplug
	rm -rvf files/vscode
	rm -rvf files/node
	rm -rvf files/tls/godev

.PHONY: clean-backend
clean-backend: # Clean Minio and MariaDb files
	@echo "Cleaning up backend files (minio data and mariadb datafiles) ..."
	rm -rvf files/db/data
	rm -rvf files/minio/data
	rm -rvf files/tls/{mariadb,minio}

.PHONY: clean-tls
clean-tls: # Clean TLS CA
	@echo "Cleaning up TLS files (CA) ..."
	rm -rvf files/tls/ca

.PHONY: clean-img
clean-img: ## Clean all related docker images
	@echo "Cleaning up all docker images (godev, minio & mariadb) ..."
	docker image rm godev:1.11.5 -f
	docker image rm godev-all:1.11.5 -f
	docker image rm godev-vscode:1.11.5 -f
	docker image rm myminio:latest -f
	docker image rm mydb:10.3 -f
	docker image rm mytls:latest -f
	docker image prune -f
	docker image rm $(docker image ls | grep none | awk '{print $3}' | xargs) -f

.PHONY: clean-net
clean-net: # Clean all related docker networks
	@echo "Cleaning up dr3dev docker network ..."
	docker network rm dr3dev || true

.PHONY: clean-all
clean-all: stop-all clean-godev clean-backend clean-tls clean-img clean-net ## Clean all data - Wipe all data

.PHONY: status
status: ## Show running containers and it's state
	@echo "-- dr3dev - Defined Networks: ---------------------------"
	@echo ""
	@docker network ls -f name=dr3dev
	@echo ""
	@echo "-- dr3dev - Built Images: -------------------------------"
	@echo ""
	@docker image ls
	@echo ""
	@echo "-- dr3dev - Running Containers: -------------------------"
	@echo ""
	@docker ps

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Possible Arguments:"
	@echo ""
	@echo "ghuser:	Setting your GitHub user will automate DRLMv3 GitHub repos setup"
	@echo "	in-place with upstream remotes, git-flow init, ..."
	@echo "	Fork of all DRLMv3 repos must be done from your GitHub account in browser."
	@echo "	example:"
	@echo "		make start-all ghuser=didacog"
	@echo ""
	@echo "tls:	Set to TRUE to enable TLS certificates autogeneration and default TLS config for services."
	@echo "	example:"
	@echo "		make start-all tls=true"
	@echo ""
	@echo "editor:	Set the godev image to use: NeoVim or VSCode (default: all)"
	@echo "	example:"
	@echo "		make start-all editor=vscode"
	@echo ""
	@echo "gitname:	Set the global git config user.name settings."
	@echo "	example:"
	@echo "		make start-all gitname='Didac Oliveira'"
	@echo ""
	@echo "gitmail:	Set the global git config user.mail settings."
	@echo "	example:"
	@echo "		make start-all gitmail=didac@drlm.org"

