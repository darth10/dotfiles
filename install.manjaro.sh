#!/bin/bash
set -xeuo pipefail

sudo pamac upgrade -a

# Install (most) programs.
sudo pamac install --no-confirm \
    base-devel kitty xkbset starship rlwrap git-delta net-tools dsh \
    editorconfig-core-c-git tofrodos aspell pass pv imagemagick \
    pasystray xfce4-volumed-pulse xfce4-screensaver xscreensaver-backends \
    feh flameshot arc-gtk-theme gtk-chtheme lxappearance redshift \
    transmission-gtk transmission-cli edk2-ovmf dnsmasq baobab-gtk3 \
    clj-kondo-bin clojure-lsp-bin ghcup-hs-bin insomnia-bin \
    cowsay cmatrix gnuchess pychess stockfish

sudo pamac remove light-locker thunderbird
sudo ln -s /usr/lib/xfce4/notifyd/xfce4-notifyd /usr/bin/xfce4-notifyd
sudo ln -s /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 /usr/bin/polkit-agent
sudo cp ./desktop/xmatrix.desktop /usr/share/applications/screensavers/

# Install asdf.
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.1 --depth 1

# Install oh-my-zsh and set as default.
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s /bin/zsh

# Copy dotfiles.
rsync -av --progress . ~ \
      --exclude .git \
      --exclude .gitmodules \
      --exclude README.md \
      --exclude desktop \
      --exclude install.manjaro.sh \
      --exclude install.sh \
      --exclude scripts \
      --exclude thinkhdaps \
      --exclude wififix

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
sudo cp ./fonts/Consolas.ttf /usr/share/fonts/TTF/
sudo cp ./fonts/PowerlineSymbols.otf /usr/share/fonts/TTF/
rm -Rf ./fonts

# Global stack configuration.
# This is here instead of in `scripts/stack-deps.bash` as it requires `sudo`.
sudo mkdir /etc/stack/
sudo chmod a+rx /etc/stack
echo 'allow-different-user: true' | sudo tee /etc/stack/config.yaml
sudo chmod a+rx /etc/stack/config.yaml

# Install dependencies for building Emacs from source.
sudo pamac install autoconf automake jansson libgccjit meson

# Build and install Emacs from source.
if [ ! -d "$HOME/projects/emacs" ]; then
    git clone git://git.sv.gnu.org/emacs.git ~/projects/emacs
    pushd ~/projects/emacs

    git checkout emacs-28.2
    ./autogen.sh
    ./configure --with-mailutils --with-json --with-imagemagick --with-native-compilation
    make
    sudo make install
    make clean
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

# Install Cask.
curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python
ln -s ~/.cask/bin/cask ~/.local/bin/cask

# Install Lima.
sudo pamac install --no-confirm \
    lima-bin docker-cli-bin qemu-desktop virt-manager \
    qemu-system-aarch64 qemu-system-arm
sudo systemctl start libvirtd
limactl completion zsh | sudo tee /usr/share/zsh/site-functions/_limactl

# Install PIA VPN.
PIA_INSTALLER=pia-linux-3.3.1-06924.run
curl -O https://installers.privateinternetaccess.com/download/$PIA_INSTALLER
chmod u+x $PIA_INSTALLER
./$PIA_INSTALLER
rm $PIA_INSTALLER

./scripts/asdf-plugins.bash
./scripts/stumpwm.bash
./scripts/node-modules.bash
./scripts/stack-deps.bash
