# dr3dev [ DRLMv3 Development, Testing &amp; Build Tool ]

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

## How to use this tool?

### 1. Clone the github repo.
<pre>
$ git clone https://github.com/didacog/dr3dev && cd dr3dev
</pre>

### 2. Build the environment.
<pre>
$ make build-all
</pre>

This is a list of all available images possible:
<pre>
$ docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
godev-vscode        1.11.5              92f50864dc00        9 seconds ago        1.31GB
godev               1.11.5              e1202457d23a        About a minute ago   680MB
myminio             latest              d3ed40bcfee8        21 hours ago         41.3MB
mydb                10.3                5b376274dd85        21 hours ago         368MB
</pre>

### 2. Start the environment.
<pre>
$ make start-backend && make start-godev
</pre>

### 4. Happy coding!! ;)

## List all available options

<pre>
$ make help

build-all                      Build all docker images [vscode: NO]
build-backend                  Builds Backend images with correct UID/GIDs for Development Environment 
build-godev                    Builds [neovim] Development Environment 
build-godev-vscode             Builds [vscode] Development Environment 
clean-all                      Clean all data - Wipe all data
clean-backend                  Clean Minio and MariaDb files
clean-godev                    Clean Golang, Vim plugin and VScode files
clean-img                      Clean all related docker images
start-backend                  Start Minio and MariaDB services
start-godev                    Start [neovim] Development Environment 
start-godev-vscode             Start [vscode] Development Environment 
status                         Show running containers and it's state
stop-backend                   Start Minio and MariaDB services
stop-godev                     Stop [neovim] Development Environment 
stop-godev-vscode              Stop [vscode] Development Environment 
</pre>


## Release History

* 0.1.0
	* Added release history in README.
	* Added `make help` & `docker image ls` in README for documentation.
	* Solved some vim plugins installation errors. Now image size is bigger //FIXIT if possible.
	* Solved last exec missing in nvim entrypoint.sh due to accidental removal.
	* Improved 'make clean-img' with safer 'prune -f' instead of 'prune -a -f'.
	* minimal docker version 18.09.1 in README.
	* added files/dots/bash/inputrc to improve terminal use (ctrl+L with bash vi mode).
	* Added VSCode config persistence and improved VSCode fonts - PR #1 - @NefixEstrada
	* Work in progres 
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
