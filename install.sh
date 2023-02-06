#!/bin/bash
set -xeuo pipefail

sudo apt install git curl
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.1 --depth 1

# Install (most) programs.
sudo add-apt-repository -u ppa:snwh/ppa
sudo apt install \
    tp-smapi-dkms thinkfan xubuntu-restricted-addons xfce4-goodies xfce4-volumed \
    zsh xkbset editorconfig tofrodos shellcheck rtags meson pv \
    kitty kitty-terminfo rlwrap tree htop resolvconf net-tools \
    fprintd fprint-doc paper-icon-theme arc-theme redshift redshift-gtk \
    feh flameshot gtk-chtheme lxappearance pasystray qt5ct qtchooser \
    xscreensaver xscreensaver-gl xscreensaver-gl-extra xscreensaver-data-extra \
    libiw-dev libfuse2 libzstd-dev libpng-dev zlib1g-dev libpam-fprintd \
    cowsay cmatrix baobab exfat-fuse exfat-utils x11-xserver-utils \
    gnuchess pychess stockfish

# Use `fprintd-enroll <uname>` and `fprintd-verify <uname>` to record
# fingerprint. Enable fingerprint for login using `sudo pam-auth-update`.

# Install oh-my-zsh and set as default.
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s /usr/bin/zsh

# Install homebrew.
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Google Chrome.
curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

# Copy all files to $HOME directory.
rsync -av --progress . ~ \
      --exclude .git \
      --exclude .gitmodules \
      --exclude install.sh \
      --exclude scripts \
      --exclude README.md \
      --exclude thinkhdaps

# Install HDAPS daemon and indicator (if needed).
#
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

# Create $HOME/projects directory.
if [ ! -d "$HOME/projects" ]; then
    mkdir ~/projects
fi

# Create $HOME/.local/bin directory.
if [ ! -d "$HOME/.local/bin" ]; then
    mkdir ~/.local/bin
fi

# Install pCloud.
curl -O https://p-def2.pcloud.com/cBZnrXB1wZijGdL3ZZZmK97o7Z2ZZ28XZkZvP5pVZ9zZNFZ8RZTFZqzZpRZJHZIHZvFZaHZgLZlRZt7ZQ5ZCy4sVZaVhmTWFT2U7Ct5C4SQcp2QIK46Ly/pcloud
mv pcloud ~/.local/bin

# Global stack configuration.
# This is here instead of in `scripts/stack-deps.bash` as it requires `sudo`.
sudo mkdir /etc/stack/
sudo chmod a+rx /etc/stack
echo 'allow-different-user: true' | sudo tee /etc/stack/config.yaml
sudo chmod a+rx /etc/stack/config.yaml

# Install dependencies for building Emacs from source.
sudo apt install autoconf automake build-essential libdbus-1-dev libgif-dev \
    libgnutls28-dev libgtk-3-dev libjansson-dev libjpeg-dev libm17n-dev libgccjit-11-dev \
    libmagickwand-dev libncurses5-dev libotf-dev libpng-dev librsvg2-dev libtiff-dev \
    libtool libxml2-dev libxpm-dev texinfo xorg-dev

# Build and install Emacs from source.
if [ ! -d "$HOME/projects/emacs" ]; then
    git clone git://git.sv.gnu.org/emacs.git ~/projects/emacs
    cd ~/projects/emacs

    git checkout emacs-28.2
    ./autogen.sh
    ./configure --with-mailutils --with-json --with-imagemagick --with-native-compilation
    make
    sudo make install
    cd ~
fi

# Install Doom Emacs and private Emacs config.
if [ ! -d "$HOME/.doom.d" ]; then
    git clone git@github.com:darth10/doom.d.git ~/.doom.d
fi
if [ ! -d "$HOME/.emacs.d" ]; then
    git clone git@github.com:hlissner/doom-emacs.git ~/projects/doom-emacs
    ln -s ~/projects/doom-emacs ~/.emacs.d
    ~/.emacs.d/bin/doom install
fi

# Install Cask.
curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python
ln -s ~/.cask/bin/cask ~/.local/bin/cask

# Install Insomnia.
echo "deb [trusted=yes arch=amd64] https://download.konghq.com/insomnia-ubuntu/ default all" \
    | sudo tee -a /etc/apt/sources.list.d/insomnia.list
sudo apt update && sudo apt install insomnia

./scripts/brew-formulae.sh
./scripts/asdf-plugins.bash
./scripts/stumpwm.bash
./scripts/node-modules.bash
./scripts/stack-deps.bash
