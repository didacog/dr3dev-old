#!/bin/bash

function mygit_status {
	echo $(STATUS=$(git status -sb) && STAGED=$(echo "$STATUS"|grep "^A"|wc -l) && MODIF=$(echo "$STATUS"|grep "M "|wc -l) && UKNOWN=$(echo "$STATUS"|grep "?? "|wc -l) && DELETE=$(echo "$STATUS"|egrep "^AD|D"|wc -l) && red=$(tput setaf 1) && green=$(tput setaf 2) && nocolor=$(tput sgr0) && [[ $STAGED -gt 0 || $MODIF -gt 0 || $UKNOWN -gt 0 || $DELETE -gt 0 ]] && echo " [${red}✗${nocolor}] $([ $STAGED -gt 0 ] && echo "✚ $STAGED ")$([ $MODIF -gt 0 ] && echo "✹ $MODIF ")$([ $UKNOWN -gt 0 ] && echo "✭ $UKNOWN ")$([ $DELETE -gt 0 ] && echo "✖ $DELETE ")" || echo " [${green}✔${nocolor}] ")
}

# Simple calculator
calc() {
	local result=""
	result="$(printf "scale=10;%s\\n" "$*" | bc --mathlib | tr -d '\\\n')"
	#						└─ default (when `--mathlib` is used) is 20

	if [[ "$result" == *.* ]]; then
		# improve the output for decimal numbers
		# add "0" for cases like ".5"
		# add "0" for cases like "-.5"
		# remove trailing zeros
		printf "%s" "$result" |
			sed -e 's/^\./0./'  \
			-e 's/^-\./-0./' \
			-e 's/0*$//;s/\.$//'
	else
		printf "%s" "$result"
	fi
	printf "\\n"
}

# Create a new directory and enter it
mkd() {
	mkdir -p "$@"
	cd "$@" || exit
}

# Make a temporary directory and enter it
tmpd() {
	local dir
	if [ $# -eq 0 ]; then
		dir=$(mktemp -d)
	else
		dir=$(mktemp -d -t "${1}.XXXXXXXXXX")
	fi
	cd "$dir" || exit
}

# Determine size of a file or total size of a directory
fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh
	else
		local arg=-sh
	fi
	# shellcheck disable=SC2199
	if [[ -n "$@" ]]; then
		du $arg -- "$@"
	else
		du $arg -- .[^.]* *
	fi
}

# Use Git’s colored diff when available
if hash git &>/dev/null ; then
	diff() {
		git diff --no-index --color-words "$@"
	}
fi

# Compare original and gzipped file size
gz() {
	local origsize
	origsize=$(wc -c < "$1")
	local gzipsize
	gzipsize=$(gzip -c "$1" | wc -c)
	local ratio
	ratio=$(echo "$gzipsize * 100 / $origsize" | bc -l)
	printf "orig: %d bytes\\n" "$origsize"
	printf "gzip: %d bytes (%2.2f%%)\\n" "$gzipsize" "$ratio"
}

# Syntax-highlight JSON strings or files
# Usage: `json '{"foo":42}'` or `echo '{"foo":42}' | json`
json() {
	if [ -t 0 ]; then # argument
		python -mjson.tool <<< "$*" | pygmentize -l javascript
	else # pipe
		python -mjson.tool | pygmentize -l javascript
	fi
}

# Run `dig` and display the most useful info
digga() {
	dig +nocmd "$1" any +multiline +noall +answer
}

# Show all the names (CNs and SANs) listed in the SSL certificate
# for a given domain
getcertnames() {
	if [ -z "${1}" ]; then
		echo "ERROR: No domain specified."
		return 1
	fi

	local domain="${1}"
	echo "Testing ${domain}…"
	echo ""; # newline

	local tmp
	tmp=$(echo -e "GET / HTTP/1.0\\nEOT" \
		| openssl s_client -connect "${domain}:443" 2>&1)

	if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
		local certText
		certText=$(echo "${tmp}" \
			| openssl x509 -text -certopt "no_header, no_serial, no_version, \
			no_signame, no_validity, no_issuer, no_pubkey, no_sigdump, no_aux")
		echo "Common Name:"
		echo ""; # newline
		echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//"
		echo ""; # newline
		echo "Subject Alternative Name(s):"
		echo ""; # newline
		echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
			| sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\\n" | tail -n +2
		return 0
	else
		echo "ERROR: Certificate not found."
		return 1
	fi
}

# `v` with no arguments opens the current directory in Vim, otherwise opens the
# given location
v() {
	if [ $# -eq 0 ]; then
		vim .
	else
		vim "$@"
	fi
}

# `o` with no arguments opens the current directory, otherwise opens the given
# location
o() {
	if [ $# -eq 0 ]; then
		xdg-open .	> /dev/null 2>&1
	else
		xdg-open "$@" > /dev/null 2>&1
	fi
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
tre() {
	tree -aC -I '.git' --dirsfirst "$@" | less -FRNX
}

# Get colors in manual pages
man() {
	env \
		LESS_TERMCAP_mb="$(printf '\e[1;31m')" \
		LESS_TERMCAP_md="$(printf '\e[1;31m')" \
		LESS_TERMCAP_me="$(printf '\e[0m')" \
		LESS_TERMCAP_se="$(printf '\e[0m')" \
		LESS_TERMCAP_so="$(printf '\e[1;44;33m')" \
		LESS_TERMCAP_ue="$(printf '\e[0m')" \
		LESS_TERMCAP_us="$(printf '\e[1;32m')" \
		man "$@"
}
# check if uri is up
isup() {
	local uri=$1

	if curl -s --head  --request GET "$uri" | grep "200 OK" > /dev/null ; then
		notify-send --urgency=critical "$uri is down"
	else
		notify-send --urgency=low "$uri is up"
	fi
}

# build go static binary from root of project
gostatic(){
	local dir=$1
	local arg=$2

	if [[ -z $dir ]]; then
		dir=$(pwd)
	fi

	local name
	name=$(basename "$dir")
	(
	cd "$dir" || exit
	export GOOS=linux
	echo "Building static binary for $name in $dir"

	case $arg in
		"netgo")
			set -x
			go build -a \
				-tags 'netgo static_build' \
				-installsuffix netgo \
				-ldflags "-w" \
				-o "$name" .
			;;
		"cgo")
			set -x
			CGO_ENABLED=1 go build -a \
				-tags 'cgo static_build' \
				-ldflags "-w -extldflags -static" \
				-o "$name" .
			;;
		*)
			set -x
			CGO_ENABLED=0 go build -a \
				-installsuffix cgo \
				-ldflags "-w" \
				-o "$name" .
			;;
	esac
	)
}

# go to a folder easily in your gopath
gogo(){
	local d=$1

	if [[ -z $d ]]; then
		echo "You need to specify a project name."
		return 1
	fi

	if [[ "$d" == github* ]]; then
		d=$(echo "$d" | sed 's/.*\///')
	fi
	d=${d%/}

	# search for the project dir in the GOPATH
	mapfile -t path < <(find "${GOPATH}/src" \( -type d -o -type l \) -iname "$d"  | awk '{print length, $0;}' | sort -n | awk '{print $2}')

	if [ "${path[0]}" == "" ] || [ "${path[*]}" == "" ]; then
		echo "Could not find a directory named $d in $GOPATH"
		echo "Maybe you need to 'go get' it ;)"
		return 1
	fi

	# enter the first path found
	cd "${path[0]}" || return 1
}

golistdeps(){
	(
	if [[ ! -z "$1" ]]; then
		gogo "$@"
	fi

	go list -e -f '{{join .Deps "\n"}}' ./... | xargs go list -e -f '{{if not .Standard}}{{.ImportPath}}{{end}}'
	)
}

