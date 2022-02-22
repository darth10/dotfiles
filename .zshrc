[[ $TERM = "tramp" ]] && unsetopt zle && PS1='$ ' && return
[[ $TERM = "dumb" ]] && unset zle_bracketed_paste && unsetopt zle && PS1='$ '

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="candy"
EMACS='emacsclient -t -a=""'

# Alias definitions.
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

export GIT_EDITOR=$EMACS
export EDITOR=$EMACS
export GEM_HOME=/var/lib/gems/1.8/bin/
export ANDROID_HOME=/home/darth10/android-sdk-linux/

# Set location of packages
# export STACK_ROOT=/data/.stack
# export NUGET_PACKAGES=/data/.nuget.packages
# export GOROOT=/usr/local/go
# export GOPATH=~/.go
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

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(fd gh git git-flow jump lein node python pip dotnet docker docker-compose kubectl)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/darth10/.local/bin:/home/darth10/.cabal/bin:/home/darth10/.npm-global/bin

# Function to change emacs directory
function set-emacs-directory {
    ln -snf $1 ~/.emacs.d
}

# Functions for git branch/status
function parse_git_dirty {
  [[ $(git diff 2> /dev/null) != "" ]] && echo "%{$fg[red]%} !!"
}
function parse_git_untracked {
  [[ $(git status -s  2> /dev/null | grep -e '??') != "" ]] && echo "%{$fg[yellow]%} ??"
}
function parse_git_dirty_cached {
  [[ $(git diff --cached 2> /dev/null) != "" ]] && echo "%{$fg_bold[green]%}++ "
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/$(parse_git_dirty_cached)%{$fg_bold[blue]%}\1$(parse_git_untracked)$(parse_git_dirty) /"
}
function parse_git_repo {
  [[ $(git status 2> /dev/null) != "" ]] && echo "%{$fg_bold[green]%}"
}

# Prompts
export PROMPT='%{$fg_bold[blue]%}$(parse_git_repo)[ $(hostname):%~ ] -> %{$reset_color%}'
export RPROMPT='%{$reset_color%}$(parse_git_branch)%{$fg_no_bold[green]%}%*%{$reset_color%}'
if [ ! $TERM = "dumb" ] && command -v starship &> /dev/null ; then
     eval "$(starship init zsh)"
fi

# cmatrix -a -b -u 7
