#!/bin/bash
set -xeuo pipefail

brew install \
    starship git-delta ghcup markdown imagemagick \
    clojure-lsp/brew/clojure-lsp-native borkdude/brew/clj-kondo
