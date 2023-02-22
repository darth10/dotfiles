#!/bin/bash
set -xeuo pipefail

sudo pamac upgrade -a

# Install (most) programs.
sudo pamac install --no-confirm \
    base-devel kitty xkbset xclip starship rlwrap git-delta net-tools dnsutils \
    editorconfig-core-c-git tofrodos aspell pass pv lsof dsh imagemagick \
    pasystray xfce4-volumed-pulse xfce4-screensaver xscreensaver-backends \
    feh flameshot arc-gtk-theme gtk-chtheme lxappearance redshift \
    transmission-gtk transmission-cli edk2-ovmf dnsmasq baobab-gtk3 \
    clj-kondo-bin clojure-lsp-bin ghcup-hs-bin insomnia-bin \
    multimarkdown cowsay cmatrix gnuchess pychess stockfish

sudo pamac remove light-locker thunderbird
sudo ln -s /usr/lib/xfce4/notifyd/xfce4-notifyd /usr/bin/xfce4-notifyd
sudo ln -s /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 /usr/bin/polkit-agent
sudo cp ./desktop/xmatrix.desktop /usr/share/applications/screensavers/

# Install asdf.
git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.11.1 --depth 1

# Install oh-my-zsh and set as default.
RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Copy dotfiles.
rsync -av --progress . $HOME \
      --exclude .git \
      --exclude .gitmodules \
      --exclude README.md \
      --exclude desktop \
      --exclude scripts

# Create $HOME/projects directory.
if [ ! -d $HOME/projects ]; then
    mkdir $HOME/projects
fi

# Create $HOME/.local/bin directory.
if [ ! -d $HOME/.local/bin ]; then
    mkdir $HOME/.local/bin
fi

# Link pCloud directory, and copy wallpapers and fonts.
ln -s $HOME/pCloudDrive $HOME/Cloud
if [ ! -d $HOME/.local/lib ]; then
    mkdir $HOME/.local/lib
fi
cp $HOME/Cloud/imgs/wallpapers/starf0rge.png $HOME/.local/lib
cp -R $HOME/Cloud/fonts .
sudo cp ./fonts/Consolas.ttf /usr/share/fonts/TTF/
sudo cp ./fonts/PowerlineSymbols.otf /usr/share/fonts/TTF/
rm -Rf ./fonts

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
./scripts/emacs.bash
./scripts/stumpwm.bash
./scripts/node-modules.bash
./scripts/stack-deps.bash
