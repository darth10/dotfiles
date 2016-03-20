#!/bin/bash

sudo apt-get install hdapsd tp-smapi-dkms thinkfan xubuntu-restricted-extras \
  git emacs24 wicd feh \
  x11-xserver-utils xscreensaver xscreensaver-gl xscreensaver-gl-extra \
  i3 xkbset gtk-chtheme lxappearance \
  cowsay cmatrix

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
