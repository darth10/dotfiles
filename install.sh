#!/bin/bash
set -euo pipefail

# Install (most) programs.
sudo apt install \
     tp-smapi-dkms thinkfan xubuntu-restricted-addons libiw-dev tofrodos tree meson \
     git editorconfig zsh shellcheck curl resolvconf htop feh docker.io ripgrep rlwrap \
     glibc-doc-reference clang-6.0 libclang-6.0-dev rtags leiningen keybase net-tools \
     x11-xserver-utils xscreensaver xscreensaver-gl xscreensaver-gl-extra xscreensaver-data-extra \
     xfce4-goodies xfce4-volumed xkbset gtk-chtheme lxappearance pasystray qt5ct qtchooser \
     guile-2.2 guile-2.2-libs guile-2.2-doc sbcl cl-quicklisp stumpwm \
     cowsay cmatrix baobab exfat-fuse exfat-utils flameshot fd-find pv \
     libpng-dev zlib1g-dev libpoppler-glib-dev libpoppler-private-dev \
     dropbox python3-pip python3-dev virtualenv markdown \
     imagemagick kitty kitty-terminfo
     gnuchess stockfish

# Set current user permissions for docker.
sudo usermod -a -G docker "$(whoami)"

# Install oh-my-zsh and set as default.
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s /usr/bin/zsh

# Copy all files to $HOME directory.
rsync -av --progress . ~ \
      --exclude .git \
      --exclude .gitmodules \
      --exclude install.sh \
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

# Install n node version manager and global node modules.
curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o ~/.local/bin/n
chmod a+x ~/.local/bin/n
sudo ~/.local/bin/n lts
sudo npm install -g sass less uglify-js js-beautify stylelint npm-check-updates

# Install Stack and Haskell dependencies.
curl -sSL https://get.haskellstack.org/ | sh
stack install cabal-install
stack exec --no-ghc-package-path -- cabal update
stack exec --no-ghc-package-path -- cabal install Cabal       # Upgrade Cabal
stack exec --no-ghc-package-path -- cabal install hasktags hlint hoogle
sudo mkdir /etc/stack/
sudo chmod a+rw /etc/stack
echo 'allow-different-user: true' | sudo tee /etc/stack/config.yaml
sudo chmod a+rw /etc/stack/config.yaml

# Install Mono compiler.
sudo apt install ca-certificates
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
sudo apt update
sudo apt install mono-roslyn

# Install Terraform switcher.
curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | sudo bash

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

# Install icons and themes.
cd ~
sudo add-apt-repository -u ppa:snwh/ppa
sudo apt install paper-icon-theme arc-theme

# Install fingerprint reader authentication.
sudo apt install libpam-fprintd fprintd fprint-doc
# Use `fprintd-enroll` and `fprintd-verify` to record fingerprint.
# Enable fingerprint for login using `sudo pam-auth-update`.
