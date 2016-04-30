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

# ...and alias tab-completion, so I can use git tab-completion with my aliases
if [ -f ~/.alias_completion.sh ]; then
  . ~/.alias_completion.sh
fi

# easily go up <n> directories. Credit: Benjamin Gilbert (www.github.com/bgilbert)
# up   == cd ..
# up 3 == cd ../../..
up() {
    local old
    old=$PWD
    for i in `seq 1 $1` ; do
        cd ..
    done
    # keep "cd -" working
    OLDPWD=$old
}

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

# the fuck?? (https://github.com/nvbn/thefuck)
eval $(thefuck --alias)

# make a dir and cd into it. Supports up to one flag.
mkgo() {
    if [ -n "$2" ]; then
        FLAG=$1
        shift
    fi
    mkdir $FLAG $1
    cd $1
}

# url encode and decode. Credit: CDown (https://gist.github.com/cdown/1163649)
urlencode() {
    # urlencode <string>

    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%s' "$c" | xxd -p -c1 |
                   while read c; do printf '%%%s' "$c"; done ;;
        esac
    done
}

urldecode() {
    # urldecode <string>

    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}
alias grep='grep --color=auto'

# Copy a safety pig onto your clipboard.
# (It's dangerous to go alone! Here, take this!)
safetypig() {
    if [ -f ~/.safety_pig ]; then
        cat ~/.safety_pig | pbcopy
    fi
}

# count how many matching procs (excluding the "grep" you just ran)

pcount() {
    if [ "$#" -lt 1 ]; then
        echo "Pass a string to grep for."
    else
        echo "$(ps -ef | grep $1 | wc -l) - 1" | bc
    fi
}