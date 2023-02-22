#!/bin/bash
set -xeuo pipefail

# Install dependencies to build Emacs from source.
sudo pamac install autoconf automake jansson libgccjit meson

# Build and install Emacs from source.
if [ ! -d $HOME/projects/emacs ]; then
    git clone git://git.sv.gnu.org/emacs.git $HOME/projects/emacs
    pushd $HOME/projects/emacs

    git checkout emacs-28.2
    ./autogen.sh
    ./configure --with-mailutils --with-json --with-imagemagick --with-native-compilation
    make
    sudo make install
    make clean
    popd
fi

# Install Doom Emacs and private Emacs config.
if [ ! -d $HOME/.doom.d ]; then
    git clone git@github.com:darth10/doom.d.git $HOME/.doom.d
fi
if [ ! -d $HOME/.emacs.d ]; then
    git clone git@github.com:hlissner/doom-emacs.git $HOME/projects/doom-emacs
    ln -s $HOME/projects/doom-emacs $HOME/.emacs.d
    $HOME/.emacs.d/bin/doom install
fi

# Install Cask.
curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python
ln -s $HOME/.cask/bin/cask $HOME/.local/bin/cask
