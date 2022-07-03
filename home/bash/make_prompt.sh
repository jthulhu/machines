#!/usr/bin/env bash

FRAME_COLOR='\[\e[36m\]'
PATH_COLOR='\[\e[01;34m\]'
USER_COLOR='\[\e[01;32m\]'
ROOT_COLOR='\[\e[01;31m\]'
RESET_COLOR='\[\e[0m\]'

PS_GIT='$(GIT_TEXT=`isgit -c -b status`; echo -en "${GIT_TEXT:+ (\[`isgit -c -b pre`\]$GIT_TEXT\[`isgit -c -b post`\])}")'
PS_DATE='\D{%d-%m-%Y}'
PS_PATH="${PATH_COLOR}\w${RESET_COLOR}"
PS_STATUS='$(RETVAL=$?; [[ "$RETVAL" -eq 0 ]] && echo -en "\[\e[37m\]" || echo -en "\[\e[01;31m\]"; echo "$RETVAL\[\e[0m\]")'
if [[ $UID -eq 0 ]];
then
    PS_USER="${ROOT_COLOR}\h${RESET_COLOR}"
else
    PS_USER="${USER_COLOR}\u${FRAME_COLOR}@${USER_COLOR}\h${RESET_COLOR}"
fi

PS_LINE1="${FRAME_COLOR}╭─{$PS_STATUS:$PS_PATH${FRAME_COLOR}}${RESET_COLOR}${PS_GIT}"
PS_LINE2="${FRAME_COLOR}╰[${RESET_COLOR}${PS_USER}${FRAME_COLOR}] $FRAME_COLOR\$ $RESET_COLOR"

export PS1="$PS_LINE1\n$PS_LINE2"
