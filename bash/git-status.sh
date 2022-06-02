#!/bin/bash

# Check if the directory is git repo
is_git () {
    if [ -d .git ]; then
	res=0
    else
	git rev-parse --git-dir 2> /dev/null;
	res=1
    fi
    echo $res
}

# Check git repo
gitPS1(){
        gitps1=$(git branch 2>/dev/null | grep "*")
            gitps1="${gitps1:+ (${gitps1/#\* /})}"
                echo "$gitps1"
}

# Check git repo status 
git_status () {
    # if [ -z "$(is_git)"  ]; then
	if [ -z "$(git status --porcelain)" ];then
	   # no git repo
	   PbS1="${_BOLD}${_GREEN}\u@${_BOLD}${_CAYN}\W$(gitPS1)${_GREEN}${_BOLD}➜ ${_RESET}"
        else
	   # git repo
	   PS1="${_BOLD}${_GREEN}\u@${_BOLD}\W${_RED}$(gitPS1)${_GREEN}${_BOLD}➜ ${_RESET}"
	fi
    # fi
	   
	   
    # echo "$PS1"
}


