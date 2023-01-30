#!/bin/bash
set -xeuo pipefail

asdf plugin add clojure
asdf plugin add dotnet
asdf plugin add fd
asdf plugin add java
asdf plugin add jq
asdf plugin add nodejs
asdf plugin add python
asdf plugin add ripgrep
asdf plugin add sbcl
asdf plugin add stack
asdf plugin add terraform

asdf install
