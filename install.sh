#!/bin/bash
set -xeuo pipefail

sudo apt install git curl
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.1 --depth 1

# Install (most) programs.
sudo apt install \
    tp-smapi-dkms thinkfan xubuntu-restricted-addons xfce4-goodies xfce4-volumed \
    zsh xkbset editorconfig tofrodos shellcheck rtags meson pass pv \
    kitty kitty-terminfo dsh rlwrap tree htop resolvconf net-tools blueman \
    fprintd fprintd-doc paper-icon-theme arc-theme redshift redshift-gtk \
    feh flameshot gtk-chtheme lxappearance pasystray qt5ct qtchooser \
    xscreensaver-gl xscreensaver-gl-extra xscreensaver-data-extra \
    libiw-dev libfuse2 libzstd-dev libpng-dev zlib1g-dev libpam-fprintd libssl-dev \
    cowsay cmatrix baobab exfat-fuse x11-xserver-utils lightdm-gtk-greeter-settings \
    vlc gnuchess pychess stockfish

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
      --exclude README.md \
      --exclude desktop \
      --exclude install.sh \
      --exclude scripts \
      --exclude thinkhdaps \
      --exclude wififix

# Install HDAPS daemon and indicator (if needed).
#
# sudo apt install hdapsd
# git submodule init
# git submodule update
# pushd thinkhdaps
# ./autogen.sh
# ./configure
# make
# sudo make install
# git reset --hard
# popd

# Create $HOME/projects directory.
if [ ! -d "$HOME/projects" ]; then
    mkdir ~/projects
fi

# Create $HOME/.local/bin directory.
if [ ! -d "$HOME/.local/bin" ]; then
    mkdir ~/.local/bin
fi

# Link pCloud directory, and copy wallpapers and fonts.
ln -s ~/pCloudDrive ~/Cloud
if [ ! -d "$HOME/.local/lib" ]; then
    mkdir ~/.local/lib
fi
cp ~/Cloud/imgs/wallpapers/starf0rge.png ~/.local/lib
cp -R ~/Cloud/fonts .
sudo cp ./fonts/Consolas.ttf /usr/share/fonts/truetype
sudo cp ./fonts/PowerlineSymbols.otf /usr/share/fonts/opentype
rm -Rf ./fonts

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
    pushd ~/projects/emacs

    git checkout emacs-28.2
    ./autogen.sh
    ./configure --with-mailutils --with-json --with-imagemagick --with-native-compilation
    make
    sudo make install
    popd
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

# Install Insomnia.
echo "deb [trusted=yes arch=amd64] https://download.konghq.com/insomnia-ubuntu/ default all" \
    | sudo tee -a /etc/apt/sources.list.d/insomnia.list
sudo apt update && sudo apt install insomnia

# Install Docker CLI (not `docker.io`).
# This is needed for zsh autocompletion of the `docker` command.
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt install docker-ce-cli

./scripts/brew-formulae.sh
./scripts/asdf-plugins.bash
./scripts/stumpwm.bash
./scripts/node-modules.bash
./scripts/stack-deps.bash

# Install Cask.
# This needs to be done after python is installed through asdf.
curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python
ln -s ~/.cask/bin/cask ~/.local/bin/cask
