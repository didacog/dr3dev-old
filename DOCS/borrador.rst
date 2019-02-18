 # docker build --build-arg MYUSERNAME=$(id -un) --build-arg MYUID=$(id -u) --build-arg MYGID=$(id -g) -t devenv . 
 # docker run -ti -v ${HOME}:${HOME} -e DISPLAY=${DISPLAY} -w $HOME devenv 

# Build DevEnv
DOCKER_BUILDKIT=1 docker build --build-arg MYUSER=$(id -un) --build-arg MYUID=$(id -u) --build-arg MYGID=$(id -g) -t dr3dev2 .

# Run DevEnv
docker run -ti -v ${PWD}/files/dots:${HOME}/dots \
-v ${PWD}/files/golang/goroot:/usr/local/go \
-v ${PWD}/files/golang/gopath:${HOME}/go \
-v ${PWD}/files/vimplug:${HOME}/.vim/plugged \ 
dr3dev2 tmux new -s DRLMv3_Dev_Env -c nvim


# TODO

- posar dr3env com a compose ??
- definir xarxa per tots accessible
- afegir ssh al dr3env?
- millorar organitzacio repo
- fer gitignore
- crear Makefile ber builds i runs ... ha de ser el punt unic de crida
- fer docu
- config TLS
- preparar cfssl per generar certificats
- fer make clean de dades: gopath, mariadb, minio, vimplug, ...
- vscode?
- pensar mes utilitats a afegir (tenir en compte tamany)
- es pot reduir mes la imatge?
- millorar entripoint dr3dev (varis casos tmux, nvim, vscode, ...)
- etc.

