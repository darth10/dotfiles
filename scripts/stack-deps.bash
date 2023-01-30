#!/bin/bash
set -xeuo pipefail

stack install cabal-install
# Upgrade Cabal
stack exec --no-ghc-package-path -- cabal update
stack exec --no-ghc-package-path -- cabal install Cabal
# Install dependencies
stack exec --no-ghc-package-path -- cabal install hasktags hlint hoogle
