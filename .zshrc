# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="candy"
EMACS='emacsclient -t -a=""'

alias gitd="git diff"
alias gitl="git log"
alias gita="git add"
alias gitb="git branch"
alias gitc="git commit"
alias gits="git status -s"
alias gitca="git commit --amend"
alias gitck="git checkout"
alias gitu="git push"
alias gituo="git push origin"
alias gituom="git push origin master"
alias gituod="git push origin develop"
alias gitp="git pull"
alias gitpo="git pull origin"
alias gitpom="git pull origin master"
alias gitpod="git pull origin develop"
alias gitpom="git pull origin master"
alias gitri="git rebase -i"
alias gitst="git status"

alias emx=$EMACS
alias wsemx="SUDO_EDITOR=\"emacsclient -c -a emacs\" sudoedit"
alias semx="SUDO_EDITOR=\"emacsclient -t -a emacs\" sudoedit"
alias erc="emacs -q -e erc"

export GIT_EDITOR=$EMACS
export EDITOR=$EMACS

# set location of packages
#
# export STACK_ROOT=/data/.stack
# export NUGET_PACKAGES=/data/.nuget.packages
# export GOPATH=/data/.go
# export PATH=$PATH:$GOPATH/bin

alias adbserver="/home/darth10/pymatter/android-sdk-linux/platform-tools/adb devices"
alias n="dsh -aM -c"

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
plugins=(git git-flow jump lein node python pip)

source $ZSH/oh-my-zsh.sh

if [[ $TERM = dumb ]]; then
  unset zle_bracketed_paste
fi

# Customize to your needs...
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/darth10/.local/bin:/home/darth10/.cabal/bin

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

# cmatrix -a -b -u 7
