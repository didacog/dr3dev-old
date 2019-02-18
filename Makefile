#.PHONY: all
#all: bin dotfiles etc ## Installs the bin and etc directory files and the dotfiles.

#arg := $(word 3, $(MAKECMDGOALS) )

.PHONY: build-godev
build-godev: ## Builds Development Environment 
	@echo "Building godev environment container ..."
	DOCKER_BUILDKIT=1 docker build --build-arg MYUSER=$(shell id -un) --build-arg MYUID=$(shell id -u) --build-arg MYGID=$(shell id -g) -t godev:1.11.5 ./docker/godev/

.PHONY: build-backend
build-backend: ## Builds Backend images with correct UID/GIDs for Development Environment 
	@echo "Building backend environment containers ..."
	@echo "Building MariaDB container image ..."
	DOCKER_BUILDKIT=1 docker build --build-arg MYUID=$(shell id -u) --build-arg MYGID=$(shell id -g) -t mydb:10.3 ./docker/backend/db/
	@echo "Building Minio container image ..."
	DOCKER_BUILDKIT=1 docker build --build-arg MYUSER=$(shell id -un) --build-arg MYUID=$(shell id -u) --build-arg MYGID=$(shell id -g) -t myminio:latest ./docker/backend/minio/

.PHONY: start-godev
start-godev: ## Start Development Environment 
	@echo "Starting Development Environemnt ..."
	mkdir -vp files/golang/gopath
	mkdir -vp files/golang/goroot
	mkdir -vp files/vimplug
	docker-compose -f docker/godev/docker-compose.yml run godev

.PHONY: stop-godev
stop-godev: ## Start Development Environment 
	@echo "Stopping Development Environemnt ..."
	docker-compose -f docker/godev/docker-compose.yml stop godev

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
clean-godev: ## Clean Golang and Vim plugin files
	@echo "Cleaning up Go dev env (golang and vim plugins) ..."
	rm -rvf files/golang
	rm -rvf files/vimplug

.PHONY: clean-backend
clean-backend: ## Clean Minio and MariaDb files
	@echo "Cleaning up backend files (minio data and mariadb datafiles) ..."
	sudo rm -rvf files/db/data
	sudo rm -rvf files/minio/data

.PHONY: clean-img
clean-img: ## Clean all related docker images
	@echo "Cleaning up all docker images (godev, minio & mariadb) ..."
	docker image rm godev:1.11.5 -f
	docker image rm minio/minio:latest -f
	docker image rm mariadb:10.3 -f
	docker image prune -a -f 

.PHONY: clean-all
clean-all: clean-godev clean-backend clean-img ## Clean all data - Wipe all data

.PHONY: status
status: ## Show running containers and it's state
	@docker ps

#.PHONY: dotfiles
#dotfiles: ## Installs the dotfiles.
#	# add aliases for dotfiles
#	for file in $(shell find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".travis.yml" -not -name ".git" -not -name ".*.swp" -not -name ".gnupg"); do \
#		f=$$(basename $$file); \
#		ln -sfn $$file $(HOME)/$$f; \
#	done; \
#	gpg --list-keys || true;
#	ln -sfn $(CURDIR)/.gnupg/gpg.conf $(HOME)/.gnupg/gpg.conf;
#	ln -sfn $(CURDIR)/.gnupg/gpg-agent.conf $(HOME)/.gnupg/gpg-agent.conf;
#	ln -fn $(CURDIR)/gitignore $(HOME)/.gitignore;
#	git update-index --skip-worktree $(CURDIR)/.gitconfig;
#	mkdir -p $(HOME)/.config;
#	ln -snf $(CURDIR)/.i3 $(HOME)/.config/sway;
#	mkdir -p $(HOME)/.local/share;
#	ln -snf $(CURDIR)/.fonts $(HOME)/.local/share/fonts;
#	ln -snf $(CURDIR)/.bash_profile $(HOME)/.profile;
#	if [ -f /usr/local/bin/pinentry ]; then \
#		sudo ln -snf /usr/bin/pinentry /usr/local/bin/pinentry; \
#	fi;

#.PHONY: etc
#etc: ## Installs the etc directory files.
#	sudo mkdir -p /etc/docker/seccomp
#	for file in $(shell find $(CURDIR)/etc -type f -not -name ".*.swp"); do \
#		f=$$(echo $$file | sed -e 's|$(CURDIR)||'); \
#		sudo ln -f $$file $$f; \
#	done
#	systemctl --user daemon-reload || true
#	sudo systemctl daemon-reload

#.PHONY: test
#test: shellcheck ## Runs all the tests on the files in the repository.
#
## if this session isn't interactive, then we don't want to allocate a
## TTY, which would fail, but if it is interactive, we do want to attach
## so that the user can send e.g. ^C through.
#INTERACTIVE := $(shell [ -t 0 ] && echo 1 || echo 0)
#ifeq ($(INTERACTIVE), 1)
#	DOCKER_FLAGS += -t
#endif
#
#.PHONY: shellcheck
#shellcheck: ## Runs the shellcheck tests on the scripts.
#	docker run --rm -i $(DOCKER_FLAGS) \
#		--name df-shellcheck \
#		-v $(CURDIR):/usr/src:ro \
#		--workdir /usr/src \
#		r.j3ss.co/shellcheck ./test.sh
#
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
