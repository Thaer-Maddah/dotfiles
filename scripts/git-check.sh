#!/bin/bash
#
 git branch --sort=committerdate | fzf --header "Cheackout Recent Branch" --preview  "git diff --color=always {1}" --preview-window=right,70% --pointer="->" | xargs git checkout
