#!/bin/bash

sudo apt-get install \
     hdapsd tp-smapi-dkms thinkfan xubuntu-restricted-extras libiw-dev \
     git emacs24 editorconfig zsh curl wicd htop feh \
     python-pip python-dev python3 python3-pip python3-dev virtualenv \
     x11-xserver-utils xscreensaver xscreensaver-gl xscreensaver-gl-extra xscreensaver-data-extra \
     i3 xkbset gtk-chtheme qt4-qtconfig lxappearance \
     cowsay cmatrix

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# zsh as default
chsh -s /usr/bin/zsh

# install RVM and signing key
gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable --ruby

# install haskell-stack
curl -sSL https://get.haskellstack.org/ | sh

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
