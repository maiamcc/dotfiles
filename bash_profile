## PATH-fu
# Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# aggregate all history to the same .history file
shopt -s histappend
export HISTSIZE=100000
export HISTFILESIZE=100000
export HISTCONTROL=ignoredups:erasedups
export HISTCONTROL=ignoreboth
export PROMPT_COMMAND="history -a;history -c;history -r;$PROMPT_COMMAND"
 
# editor is vim
export VISUAL=vim
export EDITOR="$VISUAL"

# git branch and status (credit: http://www.intridea.com/blog/2009/2/2/git-status-in-your-prompt)
function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/(\1$(parse_git_dirty))/"
}
export PS1="maia: \[\033[32m\]\w\[\033[33m\] \$(parse_git_branch)\[\033[00m\] $ "

# git tab-completion
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# speedily activate virtualenv
venv () {
if [ -f env/bin/activate ]
then
source env/bin/activate
elif [ -f bin/activate ]
then
source bin/activate
elif [ -f ~/.virtualenvs/${PWD##*/} ]
then
source ~/.virtualenvs/${PWD##*/}
else
echo "No virtualenv 'activate' file found"
fi
}

# Alias definitions -- pulled from ~/.bash_aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Work-related functions
if [ -f ~/.work_profile ]; then
    . ~/.work_profile
fi

# Work-related functions
if [ -f ~/.work_aliases ]; then
    . ~/.work_aliases
fi