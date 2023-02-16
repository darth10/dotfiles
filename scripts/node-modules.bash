#!/bin/bash
set -xeuo pipefail


# Install n node version manager and global node modules.
if [ ! -d $HOME/.npm-global ]; then
    mkdir $HOME/.npm-global
fi

export _INIT_ZSH_HISTORY_ENQUIRER_INSTALL=true
npm install -g \
    sass less insomnia-inso uglify-js js-beautify stylelint \
    npm-check-updates zsh-history-enquirer
