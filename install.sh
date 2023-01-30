#!/bin/bash
set -xeuo pipefail

sudo apt install git curl
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.1 --depth 1

# Install (most) programs.
sudo apt install \
     tp-smapi-dkms thinkfan xubuntu-restricted-addons libiw-dev tofrodos tree meson \
     editorconfig zsh shellcheck resolvconf htop feh docker.io \
     glibc-doc-reference clang-6.0 libclang-6.0-dev rtags rlwrap net-tools \
     x11-xserver-utils xscreensaver xscreensaver-gl xscreensaver-gl-extra xscreensaver-data-extra \
     xfce4-goodies xfce4-volumed xkbset gtk-chtheme lxappearance pasystray qt5ct qtchooser \
     guile-2.2 guile-2.2-libs guile-2.2-doc libzstd-dev stumpwm \
     cowsay cmatrix baobab exfat-fuse exfat-utils flameshot pv \
     libpng-dev zlib1g-dev libpoppler-glib-dev libpoppler-private-dev \
     dropbox markdown \
     imagemagick kitty kitty-terminfo
     gnuchess stockfish

# Set current user permissions for docker.
sudo usermod -a -G docker "$(whoami)"

# Install oh-my-zsh and set as default.
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s /usr/bin/zsh

# Install homebrew.
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

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

# Install git-delta.
curl -L https://github.com/dandavison/delta/releases/download/0.12.0/git-delta_0.12.0_amd64.deb -o git-delta.deb
sudo dpkg -i git-delta.deb
rm git-delta.deb

# Create $HOME/projects directory.
if [ ! -d "$HOME/projects" ]; then
    mkdir ~/projects
fi

# Create $HOME/.local/bin directory.
if [ ! -d "$HOME/.local/bin" ]; then
    mkdir ~/.local/bin
fi

# Global stack configuration.
# This is here instead of in `scripts/stack-deps.bash` as it requires `sudo`.
sudo mkdir /etc/stack/
sudo chmod a+rx /etc/stack
echo 'allow-different-user: true' | sudo tee /etc/stack/config.yaml
sudo chmod a+rx /etc/stack/config.yaml

# Install quicklisp and stumpwm dependencies.
sbcl --non-interactive --load /usr/share/common-lisp/source/quicklisp/quicklisp.lisp --eval '(quicklisp-quickstart:install :path ".quicklisp/")'
# start using ~/.quicklisp/setup.lisp
sbcl --non-interactive --load ~/.quicklisp/setup.lisp --eval '(ql-util:without-prompting (ql:add-to-init-file))'
git clone git@github.com:l04m33/clx-truetype.git ~/.quicklisp/local-projects/clx-truetype
sbcl --non-interactive --eval '(ql:quickload "clx-truetype")' --eval '(xft:cache-fonts)'
sbcl --non-interactive --eval '(ql:quickload "xembed")'
sbcl --non-interactive --eval '(ql:quickload "swank")'
sbcl --non-interactive --eval '(ql:quickload "slynk")'

# Install dependencies for building Emacs from source.
sudo apt install autoconf automake build-essential libdbus-1-dev libgif-dev \
    libgnutls28-dev libgtk-3-dev libjansson-dev libjpeg-dev libm17n-dev \
    libmagickwand-dev libncurses5-dev libotf-dev libpng-dev librsvg2-dev libtiff-dev \
    libtool libxml2-dev libxpm-dev texinfo xorg-dev

# Install starship.
sh -c "$(curl -fsSL https://starship.rs/install.sh)"

# Build and install Emacs from source.
if [ ! -d "$HOME/projects/emacs" ]; then
    git clone git://git.sv.gnu.org/emacs.git ~/projects/emacs
    cd ~/projects/emacs

    git checkout emacs-27.1
    ./configure --with-mailutils --with-json --with-imagemagick
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

# Install stumpwm config.
if [ ! -d "$HOME/.stumpwm.d" ]; then
    git clone git@github.com:darth10/stumpwm.d.git ~/projects/stumpwm.d
    ln -s ~/projects/stumpwm.d ~/.stumpwm.d
    cd ~/.stumpwm.d
    make
    cd ~
fi

# Install Insomnia.
echo "deb [trusted=yes arch=amd64] https://download.konghq.com/insomnia-ubuntu/ default all" \
    | sudo tee -a /etc/apt/sources.list.d/insomnia.list
sudo apt update && sudo apt install insomnia

# Install icons and themes.
cd ~
sudo add-apt-repository -u ppa:snwh/ppa
sudo apt install paper-icon-theme arc-theme

# Install fingerprint reader authentication.
sudo apt install libpam-fprintd fprintd fprint-doc
# Use `fprintd-enroll <uname>` and `fprintd-verify <uname>` to record
# fingerprint. Enable fingerprint for login using `sudo pam-auth-update`.

./scripts/asdf-plugins.bash
./scripts/node-modules.bash
./scripts/stack-deps.bash
