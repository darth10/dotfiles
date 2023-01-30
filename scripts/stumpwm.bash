#!/bin/bash
set -xeuo pipefail

SBCL_INSTALL_DIR=$(asdf where sbcl)
echo "export SBCL_HOME=${SBCL_INSTALL_DIR}/lib/sbcl/" >> ~/.xsessionrc

curl -O https://beta.quicklisp.org/quicklisp.lisp
curl -O https://beta.quicklisp.org/quicklisp.lisp.asc
curl -O https://beta.quicklisp.org/release-key.txt
gpg --import release-key.txt
gpg --verify quicklisp.lisp.asc quicklisp.lisp
sbcl --non-interactive --load quicklisp.lisp --eval '(quicklisp-quickstart:install :path "~/.quicklisp/")'
# start using ~/.quicklisp/setup.lisp
sbcl --non-interactive --load ~/.quicklisp/setup.lisp --eval '(ql-util:without-prompting (ql:add-to-init-file))'
git clone git@github.com:l04m33/clx-truetype.git ~/.quicklisp/local-projects/clx-truetype
sbcl --non-interactive --eval '(ql:quickload "clx-truetype")' --eval '(xft:cache-fonts)'
sbcl --non-interactive --eval '(ql:quickload "cl-ppcre")'
sbcl --non-interactive --eval '(ql:quickload "xembed")'
sbcl --non-interactive --eval '(ql:quickload "swank")'
sbcl --non-interactive --eval '(ql:quickload "slynk")'
rm quicklisp.lisp quicklisp.lisp.asc release-key.txt

git clone https://github.com/stumpwm/stumpwm.git --branch 22.11 --depth 1
cd stumpwm
./autogen.sh
./configure
make
sudo make install
cd ..
sudo cp stumpwm.desktop /usr/share/xsessions/
rm -Rf stumpwm

# Install stumpwm config.
if [ ! -d "$HOME/.stumpwm.d" ]; then
    git clone git@github.com:darth10/stumpwm.d.git ~/projects/stumpwm.d
    ln -s ~/projects/stumpwm.d ~/.stumpwm.d
    pushd ~/.stumpwm.d
    make
    popd
fi
