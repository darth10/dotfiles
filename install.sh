#!/bin/bash

sudo apt install \
     tp-smapi-dkms thinkfan xubuntu-restricted-extras libiw-dev tofrodos tree \
     git emacs25 editorconfig zsh shellcheck curl wicd resolvconf htop feh docker.io \
     glibc-doc-reference clang-6.0 libclang-6.0-dev \
     x11-xserver-utils xscreensaver xscreensaver-gl xscreensaver-gl-extra xscreensaver-data-extra \
     xkbset gtk-chtheme qt4-qtconfig lxappearance \
     guile-2.2 guile-2.2-libs guile-2.2-doc sbcl cl-quicklisp stumpwm \
     cowsay cmatrix baobab exfat-fuse exfat-utils \
     libpng-dev zlib1g-dev libpoppler-glib-dev libpoppler-private-dev \
     python-pip python-dev python3 python3-pip python3-dev virtualenv \
     gnuchess stockfish

# set current user permissions for docker
sudo usermod -a -G docker "$(whoami)"

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# zsh as default
chsh -s /usr/bin/zsh

rsync -av --progress . ~ \
      --exclude .git \
      --exclude .gitmodules \
      --exclude install.sh \
      --exclude README.md \
      --exclude thinkhdaps

# install DropBox
## for 32-bit
# wget -O - "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2019.02.14_i386.deb" > dropbox.deb
## for 64-bit
wget -O - "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2019.02.14_amd64.deb" > dropbox.deb
sudo dpkg -i dropbox.deb
rm dropbox.deb

#install keybase
## for 32-bit
# wget -O - "https://prerelease.keybase.io/keybase_i386.deb" > keybase.deb
## for 64-bit
wget -O - "https://prerelease.keybase.io/keybase_amd64.deb" > keybase.deb
sudo dpkg -i ./keybase.deb
rm keybase.deb

# install ripgrep
wget -O - "https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb" > ripgrep.deb
sudo dpkg -i ripgrep.deb
rm ripgrep.deb

# install HDAPS daemon and indicator (if needed)
# sudo apt install hdapsd
# git submodule init
# git submodule update
# cd thinkhdaps
# ./autogen.sh
# ./configure
# make
# sudo make install
# git reset --hard
# cd ~

# install n node version manager and global node modules
curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o ~/.local/bin/n
chmod a+x ~/.local/bin/n
sudo ~/.local/bin/n lts
sudo npm install -g sass less js-beautify stylelint

# install Haskell dependencies
curl -sSL https://get.haskellstack.org/ | sh
stack install cabal-install
stack exec -- cabal update
stack exec -- cabal install Cabal       # upgrade Cabal
# stack exec -- cabal install happy hasktags stylish-haskell present ghc-mod hlint hoogle structured-haskell-mode hindent
sudo mkdir /etc/stack/
sudo chmod a+rw /etc/stack
sudo echo 'allow-different-user: true' | sudo tee /etc/stack/config.yaml
sudo chmod a+rw /etc/stack/config.yaml

# install quicklisp
sbcl --non-interactive --load /usr/share/cl-quicklisp/quicklisp.lisp --eval '(quicklisp-quickstart:install :path ".quicklisp/")'
sbcl --non-interactive --load /usr/share/cl-quicklisp/quicklisp.lisp --eval '(ql-util:without-prompting (ql:add-to-init-file))'
sbcl --non-interactive --eval '(ql:quickload "clx-truetype")' # may require (xft:cache-fonts)
sbcl --non-interactive --eval '(ql:quickload "xembed")'
sbcl --non-interactive --eval '(ql:quickload "swank")'
sbcl --non-interactive --eval '(ql:quickload "slynk")'

if [ ! -d "$HOME/projects" ]; then
    mkdir ~/projects
fi

# install emacs config
if [ ! -d "$HOME/.doom.d" ]; then
    git clone git@github.com:darth10/doom.d.git ~/.doom.d
fi
if [ ! -d "$HOME/.emacs.d" ]; then
    git clone git@github.com:hlissner/doom-emacs.git ~/projects/doom-emacs
    ln -s ~/projects/doom-emacs ~/.emacs.d
    ~/.emacs.d/bin/doom install
fi

# install stumpwm config
if [ ! -d "$HOME/.stumpwm.d" ]; then
    git clone git@github.com:darth10/stumpwm.d.git ~/projects/stumpwm.d
    ln -s ~/projects/stumpwm.d ~/.stumpwm.d
    cd ~/.stumpwm.d || return
    make
fi

# install theme
cd ~ || return
sudo add-apt-repository ppa:snwh/pulp
sudo apt install paper-icon-theme arc-theme

# install fingerprint reader authentication
sudo add-apt-repository ppa:fingerprint/fprint
sudo apt install libpam-fprintd fprintd fprint-demo
# use fprintd-enroll and fprintd-verify
