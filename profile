source /opt/boxen/env.sh
PATH=$PATH:~/bin

export GREP_OPTIONS='--color=auto'
export GREP_COLOR='7;31'

export EDITOR='/usr/bin/vim'
export VISUAL='/usr/bin/vim'

function rr {
  if [ -f script/server ]; then
    script/server $@
  else
   rails server $@
  fi
}
function console {
  if [ -f script/console ]; then
    script/console $@
  else
    rails console $@
  fi
}
function rg {
  if [ -e script/generate ]; then
    script/generate $@
  else
    rails generate $@
  fi
}

source ~/.bash_aliases
source ~/.go

source ~/bin/git-completion.sh
source ~/bin/git-prompt.sh

export GIT_PS1_SHOWDIRTYSTATE=1
export PS1='\w\[\033[31m\]$(__git_ps1 " %s")\[\033[00m\] \$ '
export LESS="-R"
