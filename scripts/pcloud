#!/bin/bash
set -xeuo pipefail

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
