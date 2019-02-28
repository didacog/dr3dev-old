# dr3dev - DRLMv3 Development, Testing &amp; Build Tool 

This is a complete development environment to start contributing to the DRLMv3 FOSS Project.

Is pretended to be useful for people wanting to contribute to the DRLMv3 Project. With this tool
will be easy to start having a complete environment for development and testing.

Future will be also used to build DRLMv3, for use in workshops, test different configurations, etc.

This tool is still in it's early days and will change fast, please report any issues or ideas to 
improve it.

Could be useful also for anyone interested in start developing in Golang.

## Requirements

- docker (18.09.1 or higher - buildkit)
- docker-compose
- make

**Note**: You should have forked github.com/brainupdaters/drlm-{cli,agent,core,common} in Your GitHub account before start with the following instructions.

### Install docker

- Debian: https://docs.docker.com/install/linux/docker-ce/debian/
- CentOS: https://docs.docker.com/install/linux/docker-ce/centos/
- Binaries: https://docs.docker.com/install/linux/docker-ce/binaries/

- Post-install: https://docs.docker.com/install/linux/linux-postinstall/

**Note**: https://docs.docker.com/install/

### Install docker-compose

```sh
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
```

**Note**: https://docs.docker.com/compose/install/

## How to use this tool?

### 1. Clone the github repo.

```sh
$ git clone https://github.com/didacog/dr3dev && cd dr3dev
```

### 2. Build the environment.

```sh
$ make build-all [ editor=vscode (default: nvim) ]
```

**Note**: If you plan to use VSCode as editor, you'll need to execute `make build-godev-vscode` too.

This is a list of all available images possible:

```sh
$ docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
godev-vscode        1.12                92f50864dc00        9 seconds ago        1.31GB
godev               1.12                e1202457d23a        About a minute ago   917MB
myminio             latest              d3ed40bcfee8        21 hours ago         54.3MB
mydb                10.3                5b376274dd85        21 hours ago         368MB
mytls               latest              c50cce809f39        13 hours ago        68.1MB
```

### 3. Start the environment.

```sh
$ make start-all [ tls=true (default: false) ] [ editor=vscode (default: nvim) ] \
	[ ghuser=didacog (default: not set) ] [ gitname='Didac Oliveira' (default: not set) ] [ gitmail=didac@drlm.org (default: not set) ]
```

### 4. Happy coding!! ;)

#### godev (nvim)

This image starts with tmux session and open the editor (nvim) in first window. [Ctrl+a c] to open new terminal window inside tmux.

```sh
$ nvim go/src/github.com/<Your_GitHub_Username>
```
#### godev-vscode

This image starts with a bash terminal. You can start tmux if needed and launching code opens new X-window having the editor and terminal available.

```sh
$ code go/src/github.com/<Your_GitHub_Username>
```

**Note**: In order to have required Go binaries for vscode-go extension to work. In the Code editor window do: [ Ctrl+Shift+P ] 'Go: Install/Update Tools'

## List all available options

```sh
$ make help

build-all                      Build all docker images
clean-all                      Clean all data - Wipe all data
clean-img                      Clean all related docker images
start-all                      Start complete Development Environment
start-godev                    Start [$editor] Development Environment
status                         Show running containers and it's state
stop-all                       Stop complete Development Environment
stop-godev                     Stop [$editor] Development Environment

Possible Arguments:

ghuser:	Setting your GitHub user will automate DRLMv3 GitHub repos setup
		in-place with upstream remotes, git-flow init, ...
		Fork of all DRLMv3 repos must be done from your GitHub account in browser.
		example:
			make start-all ghuser=didacog

tls:	Set to TRUE to enable TLS certificates autogeneration and default TLS config for services.
		example:
			make start-all tls=true

editor:	Set the godev image to use: NeoVim or VSCode
		example:
			make start-all editor=vscode

gitname:	Set the global git config user.name settings.
			example:
				make start-all gitname='Didac Oliveira'

gitmail:	Set the global git config user.mail settings.
			example:
				make start-all gitmail=didac@drlm.org

```

## TODO (some pedings ...)

* :ballot_box_with_check: - Create compose file for godev (easy to read what is defined)
* :ballot_box_with_check: - Configure all containers to run with default docker network bridge for visibility
* :ballot_box_with_check: - Improve entrypoints for custom init.vim & tmux.conf files. Added .gitignore: 'files/dots/custom/'

- reduce godev image size, now: ~900MB was: 680MB - some vim plugins have to be built in builder stage.
- Add ssh service to goenv? (check image size!)
- config TLS on all containers to encrypt all service traffic (looking at cfssl)
- Are more utils/plugins/extensions needed in godev[-vscode]?? (check image size!)
- Improve Makefile
- Add more backend possible configs: HA, TLS, etc.
- Create drlmv3 build system
- Documentation and adjustments to work in Windows & Mac OSX systems, possible references:
	- WIN: https://sudhakaryblog.wordpress.com/2018/08/30/run-gui-app-on-windows-xlaunch-vcxsrv/
	- OSX: https://gist.github.com/cschiewek/246a244ba23da8b9f0e7b11a68bf3285
- Mutual TLS:
	- Use TLS from client side GORM (https://stackoverflow.com/questions/52962028/how-to-create-ssl-connection-to-mysql-with-gorm)
	- Use TLS from client side MINIO cli-sdk
- Move protoc installation under files/golang/protoc and adjust volume mounts.
- git global config persistence (user.email & user.name)
- etc.

Please if you have ideas to improve this please open an issue, PR, ... We can discuss about it and see how to implement it.

## Changelog - Release History 

* 0.1.1
	* Added TLS service with cfssl container to provide TLS certificates to the entire environment.
	* Automated git clone, gitflow init of all drlm3 repos. Use arg ghuser="YourGitHubUser" in make [start-godev|start-godev-vscode].
	* Added docker network creation to enable correct communication between all containers in the environment.
	* Updated README with new features
	* Golang 1.12 released, changed to use GO version 1.12.
	* Solved network resoultion between containers in env.
	* Solved ghuser argument issues. Now does what is meant to do.
	* Improved Makefile commands with args: tls=[true|false(default)] editor=[vscode|nvim(default)]
	* Updated README instructions to match Makefile commands.
	* Solved Go Modules now working in godev.
	* Solved build-net error in Makefile
	* More info in `make status`
	* Added protobuffers install in entrypoints and other DRLM go tools dependencies like cobra.
	* Added gitname & gitmail arguments to configure git global name and mail for commit signatures.
	* Improved Makefile, more simple and with smaller help output.
	* Improved vscode compose file to avoid vscode crashes (ipc: host & -v /dev/shm:/dev/shm)
	* Solved some minor issues
	* Added required go get github.com/brainupdaters/drlm-{core,cli,common,agent} to godev.
	* Work in progres 
* 0.1.0
	* Added release history in README.
	* Added `make help` & `docker image ls` in README for documentation.
	* Solved some vim plugins installation errors. Now image size is bigger //FIXIT if possible.
	* Solved last exec missing in nvim entrypoint.sh due to accidental removal.
	* Improved 'make clean-img' with safer 'prune -f' instead of 'prune -a -f'.
	* minimal docker version 18.09.1 in README.
	* added files/dots/bash/inputrc to improve terminal use (ctrl+L with bash vi mode).
	* Added VSCode config persistence and improved VSCode fonts - PR #1 - @NefixEstrada.
	* Added install instructions for docker & docker-compose.
	* Added support for custom configs init.vim and tmux.conf in `files/dots/custom/`.
	* Moved TODO list to README file.
	* Added example/explanation of how to start coding in godev - README.
	* Improved README by PR#2 - @NefixEstrada.
	* Added support for custom bash config in `files/dots/custom/*.bash`.
	* Cleanup of bash configs.
* 0.0.9
	* Added new goenv-vscode image.
	* Quick start in README.
	* asked for testing to @proura @krbu @NefixEstrada.
* 0.0.8
	* Improved build times with BUILDKIT and Multi-stage builds.
	* more reorgs. and little changes.
* 0.0.7
	* Dockerfiles for MariaDB & Minio services to fix user permisions (running with your UID/GID inside container).
	* Compose file for godev image (improves documentation).
	* Same bridge network for all containers in the environment.
	* more reorganizations and changes.
* 0.0.6
	* Added MariaDB configurations in files/db/conf .
	* Solved Vim plugins install errors (entrypoint.sh).
	* reorganization of structure docker/[backend|godev] files/[dots|vimplug|golang/[goroot|gopath]|db|minio].
	* New commands in Makefile.
* 0.0.5
	* added Makefile with build and start commands.
	* godev dockerfile improvements.
	* asked for testing to @krbu.
* 0.0.4
	* Reorganizations in structure.
	* Added dotfiles support (pending custom dotfiles).
	* godev Dockerfile reorg. Moved install Golang and Vim plugins to entrypoint.sh (persistence).
	* Improved build times and image sizes.
* 0.0.3
	* Added GOROOT, GOPATH, Vim Plugins persistence in project 1st aproach (pending clean/wipe).
* 0.0.2
	* Tested various base image options (debian,alpine, etc.) see OLD dir.
	* godev Dockerfile based in archlinux/base with golang, neovim, tmux, etc.
* 0.0.1
    * 1st docker-compose.yml file for backend services.

## Author

* Didac Oliveira – [@didacog](https://twitter.com/didacog) – didac@drlm.org

## Collaborators

* Nefix Estrada - [@NefixEstrada] - nefix@drlm.org

## License

Distributed under the GPLv3 license. See ``LICENSE`` for more information.

[https://github.com/didacog](https://github.com/didacog/)
