#!/usr/bin/env bash
# My custom command prompt
#

function safe_append_prompt_command {
    local prompt_re
    # Set OS dependent exact match regular expression
    if [[ ${OSTYPE} == darwin* ]]; then
      # macOS
      prompt_re="[[:<:]]${1}[[:>:]]"
    else
      # Linux, FreeBSD, etc.
      prompt_re="\<${1}\>"
    fi

    if [[ ${PROMPT_COMMAND} =~ ${prompt_re} ]]; then
      return
    elif [[ -z ${PROMPT_COMMAND} ]]; then
      PROMPT_COMMAND="${1}"
    else
      PROMPT_COMMAND="${1};${PROMPT_COMMAND}"
    fi
}

prompt_git() {
	local s='';
	local branchName='';

	# Check if the current directory is in a Git repository.
	if [ "$(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}")" == '0' ]; then

		# check if the current directory is in .git before running git checks
		if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]; then

			if [[ -O "$(git rev-parse --show-toplevel)/.git/index" ]]; then
				git update-index --really-refresh -q &> /dev/null;
			fi;

			# Check for uncommitted changes in the index.
			if ! git diff --quiet --ignore-submodules --cached; then
				s+='+';
			fi;

			# Check for unstaged changes.
			if ! git diff-files --quiet --ignore-submodules --; then
				s+='!';
			fi;

			# Check for untracked files.
			if [ -n "$(git ls-files --others --exclude-standard)" ]; then
				s+='?';
			fi;

			# Check for stashed files.
			if git rev-parse --verify refs/stash &>/dev/null; then
				s+='$';
			fi;

		fi;

		# Get the short symbolic ref.
		# If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
		# Otherwise, just give up.
		branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
			git rev-parse --short HEAD 2> /dev/null || \
			echo '(unknown)')";

		[ -n "${s}" ] && s=" [${s}]";

		echo -e "${1}${bold_purple}${branchName}${bold_blue}${s}${normal}:";
	else
		return;
	fi;
}

prompt() {
    ps_host="${bold_blue}\h${normal}";
    ps_user="${bold_green}\u${normal}";
    ps_user_mark="${bold_green}$ ${normal}"
    ps_root="${bold_red}\u${normal}";
    ps_root_mark="${bold_red}# ${normal}"
    ps_path="${bold_yellow}\w${normal}";
	ps_git="$(prompt_git)";

	# make it work
	case $(id -u) in
		0) PS1="$ps_root@$ps_host:$ps_git$ps_path〉\n$ps_root_mark"
		;;
		*) PS1="$ps_user@$ps_host:$ps_git$ps_path〉\n$ps_user_mark"
		;;
	esac
}

safe_append_prompt_command prompt
