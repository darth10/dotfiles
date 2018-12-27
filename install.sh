#!/bin/bash

sudo apt-get install \
     hdapsd tp-smapi-dkms thinkfan xubuntu-restricted-extras libiw-dev \
     git emacs25 editorconfig zsh curl wicd htop tree feh docker glibc-doc-reference \
     x11-xserver-utils xscreensaver xscreensaver-gl xscreensaver-gl-extra xscreensaver-data-extra \
     i3 xkbset gtk-chtheme qt4-qtconfig lxappearance \
     sbcl cl-quicklisp stumpwm \
     cowsay cmatrix baobab \
     python-pip python-dev python3 python3-pip python3-dev virtualenv

# set current user permissions for docker
sudo usermod -a -G docker $(whoami)

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# zsh as default
chsh -s /usr/bin/zsh

rsync -av --progress . ~ \
      --exclude .git \
      --exclude .gitmodules \
      --exclude install.sh \
      --exclude thinkhdaps

# install DropBox
## for 32-bit
# wget -O - "https://www.dropbox.com/download?dl=packages/debian/dropbox_2015.10.28_i386.deb" > dropbox.deb
## for 64-bit
wget -O - "https://www.dropbox.com/download?dl=packages/debian/dropbox_2015.10.28_amd64.deb" > dropbox.deb
sudo dpkg -i dropbox.deb
rm dropbox.deb

# install HDAPS indicator
git submodule init
git submodule update
cd thinkhdaps
./autogen.sh
./configure
make
sudo make install
git reset --hard
cd ..

# install i3pystatus
sudo pip3 install i3pystatus netifaces colour basiciw pulsectl

# install node and global npm modules
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install nodejs
sudo npm install -g sass less

# install Haskell dependencies
curl -sSL https://get.haskellstack.org/ | sh
stack install cabal-install
cabal update
cabal install Cabal		# upgrade Cabal
cabal install happy hasktags stylish-haskell present ghc-mod hlint hoogle structured-haskell-mode hindent
sudo mkdir /etc/stack/
sudo chmod a+rw /etc/stack
sudo echo 'allow-different-user: true' > /etc/stack/config.yaml
sudo chmod a+rw /etc/stack/config.yaml

# install quicklisp
sbcl --load /usr/share/cl-quicklisp/quicklisp.lisp --eval '(quicklisp-quickstart:install :path ".quicklisp/")'
sbcl --load /usr/share/cl-quicklisp/quicklisp.lisp --eval '(ql-util:without-prompting (ql:add-to-init-file))'
sbcl --eval '(ql:quickload "clx-truetype")'
sbcl --eval '(ql:quickload "xembed")'
sbcl --eval '(ql:quickload "swank")'

# install emacs config
if [ ! -d "~/.emacs.d"] then
   cd ~
   git clone https://github.com/darth10/emacs.d.git .emacs.d
fi

# install stumpwm config
if [ ! -d "~/.stumpwm.d"] then
   cd ~
   git clone https://github.com/darth10/stumpwm.d.git .stumpwm.d
   ln -s ~/.stumpwm.d/init.lisp ~/.stumpwmrc
   cd ~/.stumpwm.d
   git submodule init
   git submodule update
fi

# install theme
cd ~
sudo apt-get install paper-icon-theme
git clone https://github.com/snwh/paper-gtk-theme.git
./paper-gtk-theme/install-gtk-theme.sh
rm -Rf ./paper-gtk-theme
