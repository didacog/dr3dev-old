#.PHONY: all
#all: bin dotfiles etc ## Installs the bin and etc directory files and the dotfiles.

#arg := $(word 3, $(MAKECMDGOALS) )

.PHONY: build-godev
build-godev: ## Builds [neovim] Development Environment 
	@echo "Building godev [neovim] Environment container image ..."
	DOCKER_BUILDKIT=1 docker build --build-arg MYUSER=$(shell id -un) --build-arg MYUID=$(shell id -u) --build-arg MYGID=$(shell id -g) -t godev:1.11.5 ./docker/godev/nvim/

.PHONY: build-godev-vscode
build-godev-vscode: ## Builds [vscode] Development Environment 
	@echo "Building godev [vscode] Environment container image ..."
	DOCKER_BUILDKIT=1 docker build --build-arg MYUSER=$(shell id -un) --build-arg MYUID=$(shell id -u) --build-arg MYGID=$(shell id -g) -t godev-vscode:1.11.5 ./docker/godev/vscode/

.PHONY: build-backend
build-backend: ## Builds Backend images with correct UID/GIDs for Development Environment 
	@echo "Building MariaDB container image ..."
	DOCKER_BUILDKIT=1 docker build --build-arg MYUID=$(shell id -u) --build-arg MYGID=$(shell id -g) -t mydb:10.3 ./docker/backend/db/
	@echo "Building Minio container image ..."
	DOCKER_BUILDKIT=1 docker build --build-arg MYUSER=$(shell id -un) --build-arg MYUID=$(shell id -u) --build-arg MYGID=$(shell id -g) -t myminio:latest ./docker/backend/minio/

.PHONY: build-all
build-all: build-godev build-backend ## Build all docker images [vscode: NO]

.PHONY: start-godev
start-godev: ## Start [neovim] Development Environment 
	@echo "Starting [neovim] Development Environemnt ..."
	mkdir -vp files/golang/gopath
	mkdir -vp files/golang/goroot
	mkdir -vp files/vimplug
	docker-compose -f docker/godev/nvim/docker-compose.yml run godev

.PHONY: start-godev-vscode
start-godev-vscode: ## Start [vscode] Development Environment 
	@echo "Starting [vscode] Development Environemnt ..."
	mkdir -vp files/golang/gopath
	mkdir -vp files/golang/goroot
	mkdir -vp files/vscode
	docker-compose -f docker/godev/vscode/docker-compose.yml run godev

.PHONY: stop-godev
stop-godev: ## Stop [neovim] Development Environment 
	@echo "Stopping [neovim] Development Environemnt ..."
	docker-compose -f docker/godev/nvim/docker-compose.yml stop godev

.PHONY: stop-godev-vscode
stop-godev-vscode: ## Stop [vscode] Development Environment 
	@echo "Stopping [vscode] Development Environemnt ..."
	docker-compose -f docker/godev/vscode/docker-compose.yml stop godev

.PHONY: start-backend
start-backend: ## Start Minio and MariaDB services
	@echo "Starting Minio and MariaDB ..."
	mkdir -vp files/db/data
	mkdir -vp files/minio/data
	docker-compose -f docker/backend/dc-simple.yml up -d

.PHONY: stop-backend
stop-backend: ## Start Minio and MariaDB services
	@echo "Stopping Minio and MariaDB ..."
	docker-compose -f docker/backend/dc-simple.yml down

.PHONY: clean-godev
clean-godev: ## Clean Golang, Vim plugin and VScode files
	@echo "Cleaning up Go dev env (golang and vim plugins) ..."
	sudo rm -rvf files/golang
	rm -rvf files/vimplug
	rm -rvf files/vscode

.PHONY: clean-backend
clean-backend: ## Clean Minio and MariaDb files
	@echo "Cleaning up backend files (minio data and mariadb datafiles) ..."
	rm -rvf files/db/data
	rm -rvf files/minio/data

.PHONY: clean-img
clean-img: ## Clean all related docker images
	@echo "Cleaning up all docker images (godev, minio & mariadb) ..."
	docker image rm godev:1.11.5 -f
	docker image rm godev-vscode:1.11.5 -f
	docker image rm myminio:latest -f
	docker image rm mydb:10.3 -f
	docker image prune -f 

.PHONY: clean-all
clean-all: clean-godev clean-backend clean-img ## Clean all data - Wipe all data

.PHONY: status
status: ## Show running containers and it's state
	@docker ps

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
