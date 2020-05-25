#!/bin/bash
set -euo pipefail

sudo apt install \
     tp-smapi-dkms thinkfan xubuntu-restricted-addons libiw-dev tofrodos tree meson \
     git emacs editorconfig zsh shellcheck curl resolvconf htop feh docker.io ripgrep \
     glibc-doc-reference clang-6.0 libclang-6.0-dev leiningen keybase \
     x11-xserver-utils xscreensaver xscreensaver-gl xscreensaver-gl-extra xscreensaver-data-extra \
     xkbset gtk-chtheme lxappearance \
     guile-2.2 guile-2.2-libs guile-2.2-doc sbcl cl-quicklisp stumpwm \
     cowsay cmatrix baobab exfat-fuse exfat-utils flameshot \
     libpng-dev zlib1g-dev libpoppler-glib-dev libpoppler-private-dev \
     dropbox python3-pip python3-dev virtualenv \
     gnuchess stockfish

# install dependencies for building emacs from source
sudo apt install \
     autoconf automake libtool texinfo build-essential xorg-dev libgtk-3-dev \
     libjpeg-dev libncurses5-dev libdbus-1-dev libgif-dev libtiff-dev libm17n-dev \
     libpng-dev librsvg2-dev libotf-dev libgnutls28-dev libxml2-dev libxpm-dev

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
curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o ~/n
chmod a+x ~/n
sudo mv ~/n /usr/local/bin/
sudo n lts
sudo npm install -g sass less uglify-js js-beautify stylelint npm-check-updates

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

# install Mono compiler
sudo apt install ca-certificates
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
sudo apt update
sudo apt install mono-roslyn

# install quicklisp
sbcl --non-interactive --load /usr/share/common-lisp/source/quicklisp/quicklisp.lisp --eval '(quicklisp-quickstart:install :path ".quicklisp/")'
# start using ~/.quicklisp/setup.lisp
sbcl --non-interactive --load ~/.quicklisp/setup.lisp --eval '(ql-util:without-prompting (ql:add-to-init-file))'
git clone git@github.com:l04m33/clx-truetype.git ~/.quicklisp/local-projects/clx-truetype
sbcl --non-interactive --eval '(ql:quickload "clx-truetype")' --eval '(xft:cache-fonts)'
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
sudo add-apt-repository -u ppa:snwh/ppa
sudo apt install paper-icon-theme arc-theme

# install fingerprint reader authentication
sudo apt install libpam-fprintd fprintd fprint-doc
# use `fprintd-enroll` and `fprintd-verify`
# enable for login using `sudo pam-auth-update`
