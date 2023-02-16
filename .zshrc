[[ $TERM = "tramp" ]] && unsetopt zle && PS1='$ ' && return
[[ $TERM = "dumb" ]] && unset zle_bracketed_paste && unsetopt zle && PS1='$ '

# Alias definitions.
if [ -f $HOME/.aliases ]; then
    . $HOME/.aliases
fi

EMACS='emacsclient -t -a=""'
export GIT_EDITOR=$EMACS
export EDITOR=$EMACS
export GEM_HOME=/var/lib/gems/1.8/bin/
export ANDROID_HOME=$HOME/projects/android-sdk-linux/

# Key bindings for Kitty/OSX.
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
# To use M-b and M-f on OSX, save the following to ~/Library/KeyBindings/DefaultKeyBinding.dict:
: '
{
    "~d" = "deleteWordForward:";
    "^w" = "deleteWordBackward:";
    "~f" = "moveWordForward:";
    "~b" = "moveWordBackward:";
}
'

# Set location of packages
# export STACK_ROOT=/data/.stack
# export NUGET_PACKAGES=/data/.nuget.packages
# export GOROOT=/usr/local/go
# export GOPATH=$HOME/.go
# export PATH=$PATH:$GOPATH/bin:$GOROOT/bin

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Brew:
if [[ $OSTYPE == 'darwin'* ]] && [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ $OSTYPE == 'linux-gnu' ]] && [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
if command -v brew &> /dev/null ; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# Password store:
export PASSWORD_STORE_DIR=$HOME/Cloud/pass
export PASSWORD_STORE_ENABLE_EXTENSIONS=true

# Customize to your needs.
export PATH=$PATH:$HOME/.local/bin:$HOME/.cabal/bin:$HOME/.npm-global/bin

# Function to change emacs directory.
function set-emacs-directory {
    ln -snf $1 $HOME/.emacs.d
}

# Prompt:
if [ ! $TERM = "dumb" ] && command -v starship &> /dev/null ; then
     eval "$(starship init zsh)"
fi

# oh-my-zsh configuration:
plugins=(asdf brew fd ripgrep gh git git-flow jump lein node pass python pip dotnet docker docker-compose kubectl)
source $HOME/.oh-my-zsh/oh-my-zsh.sh

# cmatrix -a -b -u 7
