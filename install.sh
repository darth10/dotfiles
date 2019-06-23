#!/bin/bash

sudo apt install \
     tp-smapi-dkms thinkfan xubuntu-restricted-extras libiw-dev tofrodos \
     git emacs25 editorconfig zsh curl wicd resolvconf htop tree feh docker glibc-doc-reference \
     x11-xserver-utils xscreensaver xscreensaver-gl xscreensaver-gl-extra xscreensaver-data-extra \
     xkbset gtk-chtheme qt4-qtconfig lxappearance \
     guile-2.2 guile-2.2-libs guile-2.2-doc sbcl cl-quicklisp stumpwm \
     cowsay cmatrix baobab \
     libpng-dev zlib1g-dev libpoppler-glib-dev libpoppler-private-dev \
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
      --exclude README.md \
      --exclude thinkhdaps

# install DropBox
## for 32-bit
# wget -O - "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2019.02.14_i386.deb" > dropbox.deb
## for 64-bit
wget -O - "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2019.02.14_amd64.deb" > dropbox.deb
sudo dpkg -i dropbox.deb
rm dropbox.deb

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

# install node and global npm modules
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt install nodejs
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
sbcl --non-interactive --load /usr/share/cl-quicklisp/quicklisp.lisp --eval '(quicklisp-quickstart:install :path ".quicklisp/")'
sbcl --non-interactive --load /usr/share/cl-quicklisp/quicklisp.lisp --eval '(ql-util:without-prompting (ql:add-to-init-file))'
sbcl --non-interactive --eval '(ql:quickload "clx-truetype")' # may require (xft:cache-fonts)
sbcl --non-interactive --eval '(ql:quickload "xembed")'
sbcl --non-interactive --eval '(ql:quickload "swank")'

# install emacs config
if [ ! -d "~/.emacs.d"] then
   git clone git@github.com:darth10/holy-emacs.git ~/.emacs.d
   cd ~/.emacs.d
   make
fi

# install stumpwm config
if [ ! -d "~/.stumpwm.d"] then
   git clone git@github.com:darth10/stumpwm.d.git ~/.stumpwm.d
   cd ~/.stumpwm.d
   make
fi

# install theme
cd ~
sudo add-apt-repository ppa:snwh/pulp
sudo apt install paper-icon-theme arc-theme

# install fingerprint reader authentication
sudo add-apt-repository ppa:fingerprint/fprint
sudo apt install libpam-fprintd fprintd fprint-demo
# use fprintd-enroll and fprintd-verify
