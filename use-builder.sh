#!/bin/bash

echo "switching to build env ${1}"
if [ -e /builder/${1}/buildenv.inc ]; then
    cd /builder/${1}
    source /builder/${1}/buildenv.inc
    bash --rcfile <(echo "PS1='[${1}]\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\u@\h:\w# '") -i 
fi

