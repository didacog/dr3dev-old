# dr3dev [ DRLMv3 Development, Testing &amp; Build Tool ]

This is a complete development environment to start contributing to the DRLMv3 FOSS Project.

Is pretended to be useful for people wanting to contribute to the DRLMv3 Project. With this tool
will be easy to start having a complete environment for development and testing.

Future will be also used to build DRLMv3, for use in workshops, test different configurations, etc.

This tool is still in it's early days and will change fast, please report any issues or ideas to 
improve it.

Could be useful also for anyone interested in start developing in Golang.

## Requirements

- docker
- docker-compose

## How to use this tool?

### 1. Clone the github repo.
<pre>
$ git clone https://github.com/didacog/dr3dev && cd dr3dev
</pre>

### 2. Build the environment.
<pre>
$ make build-all
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
