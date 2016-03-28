#!/bin/bash

sudo apt-get install \
     hdapsd tp-smapi-dkms thinkfan xubuntu-restricted-extras libiw-dev \
     git emacs24 zsh wicd htop feh \
     python-pip python-dev python3 python3-pip python3-dev virtualenv \
     x11-xserver-utils xscreensaver xscreensaver-gl xscreensaver-gl-extra \
     i3 xkbset gtk-chtheme qt4-qtconfig lxappearance \
     cowsay cmatrix

chsh -s /usr/bin/zsh

rsync -av --progress . ~ \
      --exclude .git \
      --exclude .gitmodules \
      --exclude install.sh \
      --exclude thinkhdaps

# install DropBox
## for 32-bit
wget -O - "https://www.dropbox.com/download?dl=packages/debian/dropbox_2015.10.28_i386.deb" > dropbox.deb
## for 64-bit
# wget -O - "https://www.dropbox.com/download?dl=packages/debian/dropbox_2015.10.28_amd64.deb" > dropbox.deb
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
sudo pip3 install i3pystatus netifaces colour basiciw libpulseaudio
