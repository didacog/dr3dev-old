golang-version ?= 1.13.6
# golang-arch ?= $(shell uname -m)
protobuf-version ?= 3.11.2
protobuf-arch ?= $(shell uname -m)
mariadb-version ?= 10.3

.PHONY: build
build: build-net build-tls build-backend build-godev

.PHONY: build-net
build-net:
	@echo "Setting up dr3dev docker network ..."
	docker network create --attachable dr3dev || true

.PHONY: build-tls
build-tls:
	@echo "Building CFSSL container image ..."
	DOCKER_BUILDKIT=1 docker build --build-arg MYUID=$(shell id -u) --build-arg MYGID=$(shell id -g) -t dr3dev-tls:latest ./docker/tls/

.PHONY: build-backend
build-backend:
	@echo "Building MariaDB container image ..."
	DOCKER_BUILDKIT=1 docker build --build-arg MYUID=$(shell id -u) --build-arg MYGID=$(shell id -g) --build-arg MARIADB_VERSION=$(mariadb-version) -t dr3dev-db:$(mariadb-version) ./docker/backend/db/
	@echo "Building Minio container image ..."
	DOCKER_BUILDKIT=1 docker build --build-arg MYUSER=$(shell id -un) --build-arg MYUID=$(shell id -u) --build-arg MYGID=$(shell id -g) -t dr3dev-minio:latest ./docker/backend/minio/

.PHONY: build-godev
build-godev:
	@echo "Building godev Environment container image ..."
	DOCKER_BUILDKIT=1 docker build \
		--build-arg MYUSER=$(shell id -un) \
		--build-arg MYUID=$(shell id -u) \
		--build-arg MYGID=$(shell id -g) \
		--build-arg DOCKERGID=$(shell cat /etc/group | grep docker | cut -d: -f3) \
		--build-arg DR3DEV=$(PWD) \
		--build-arg GOLANG_VERSION=$(golang-version) \
		--build-arg PROTOBUF_VERSION=$(protobuf-version) \
		--build-arg PROTOBUF_ARCH=$(protobuf-arch) \
		-t dr3dev-godev:$(golang-version) ./docker/godev/

.PHONY: start
start: start-tls start-backend start-godev

.PHONY: start-tls
start-tls:
	@echo "Starting CFSSL service ..."
	mkdir -vp files/tls/ca
	docker-compose -f docker/tls/docker-compose.yml up -d

.PHONY: start-backend
start-backend:
	@echo "Starting Minio and MariaDB ..."
	mkdir -vp files/db/data
	mkdir -vp files/minio/data
	mkdir -vp files/tls/{mariadb,minio}
	files/tls/sh/gencert.sh mariadb
	files/tls/sh/gencert.sh minio
	MARIADB_VERSION=$(mariadb-version) docker-compose -f docker/backend/docker-compose.yml up -d

.PHONY: start-godev
start-godev:
	mkdir -vp files/tls/godev
	files/tls/sh/gencert.sh godev

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
ifdef offline
	touch files/golang/gopath/offline
endif
ifndef offline
	rm -f files/golang/gopath/offline
endif
	mkdir -vp files/golang/goroot
	mkdir -vp files/golang/protoc
	mkdir -vp files/vimplug
	mkdir -vp files/vscode
	mkdir -vp files/node
	GOLANG_VERSION=$(golang-version) docker-compose -f docker/godev/docker-compose.yml run godev

.PHONY: stop
stop: stop-tls stop-backend stop-godev

.PHONY: stop-tls
stop-tls:
	@echo "Stopping CFSSL service ..."
	docker-compose -f docker/tls/docker-compose.yml down

.PHONY: stop-backend
stop-backend:
	@echo "Stopping Minio and MariaDB ..."
	MARIADB_VERSION=$(mariadb-version) docker-compose -f docker/backend/docker-compose.yml down

.PHONY: stop-godev
stop-godev:
	@echo "Stopping [complete] Development Environemnt ..."
	GOLANG_VERSION=$(golang-version) docker-compose -f docker/godev/docker-compose.yml stop godev

.PHONY: clean
clean: stop clean-img clean-net clean-tls clean-backend clean-godev

.PHONY: clean-img
clean-img:
	@echo "Cleaning up all docker images (godev, minio & mariadb) ..."
	docker image rm dr3dev-godev:$(golang-version) -f
	docker image rm dr3dev-minio:latest -f
	docker image rm dr3dev-db:$(mariadb-version) -f
	docker image rm dr3dev-tls:latest -f

.PHONY: clean-net
clean-net:
	@echo "Cleaning up dr3dev docker network ..."
	docker network rm dr3dev || true

.PHONY: clean-tls
clean-tls:
	@echo "Cleaning up TLS files (CA) ..."
	rm -rvf files/tls/ca

.PHONY: clean-backend
clean-backend:
	@echo "Cleaning up backend files (minio data and mariadb datafiles) ..."
	rm -rvf files/db/data
	rm -rvf files/minio/data
	rm -rvf files/tls/{mariadb,minio}

.PHONY: clean-godev
clean-godev:
	@echo "Cleaning up Go dev env (golang and vim plugins) ..."
	sudo rm -rvf files/golang
	rm -rvf files/vimplug
	rm -rvf files/vscode
	rm -rvf files/node
	rm -rvf files/tls/godev

.PHONY: status
status:
	@echo "-- dr3dev - Defined Networks: ---------------------------"
	@echo ""
	@docker network ls -f name=dr3dev
	@echo ""
	@echo "-- dr3dev - Built Images: -------------------------------"
	@echo ""
	@docker image ls | grep dr3dev
	@echo ""
	@echo "-- dr3dev - Running Containers: -------------------------"
	@echo ""
	@docker ps | grep dr3dev || echo -e "No running containers\n"

.PHONY: help
help:
	@echo "Possible Arguments:"
	@echo ""
	@echo "ghuser:	Setting your GitHub user will automate DRLMv3 GitHub repos setup"
	@echo "	in-place with upstream remotes, git-flow init, ..."
	@echo "	Fork of all DRLMv3 repos must be done from your GitHub account in browser."
	@echo "	example:"
	@echo "		make start-all ghuser=didacog"
	@echo ""
	@echo "gitname:	Set the global git config user.name settings."
	@echo "	example:"
	@echo "		make start-all gitname='Didac Oliveira'"
	@echo ""
	@echo "gitmail:	Set the global git config user.mail settings."
	@echo "	example:"
	@echo "		make start-all gitmail=didac@drlm.org"
	@echo ""
	@echo "offline:	Runs dr3dev offline"
	@echo "	example:"
	@echo "		make start-all offline=true"
