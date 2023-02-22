#!/bin/bash
set -xeuo pipefail

sudo mkdir /etc/stack/
sudo chmod a+rx /etc/stack
echo 'allow-different-user: true' | sudo tee /etc/stack/config.yaml
sudo chmod a+rx /etc/stack/config.yaml

stack install cabal-install
# Upgrade Cabal
stack exec --no-ghc-package-path -- cabal update
stack exec --no-ghc-package-path -- cabal install Cabal
# Install dependencies
stack exec --no-ghc-package-path -- cabal install hasktags hlint hoogle
