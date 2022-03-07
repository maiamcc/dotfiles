
#### FIG ENV VARIABLES ####
# Please make sure this block is at the start of this file.
[ -s ~/.fig/shell/pre.sh ] && source ~/.fig/shell/pre.sh
#### END FIG ENV VARIABLES ####

export VIM="$HOME/.vim"

export MAIN_BRANCH="master"  # often master but can override in bash_profile_local

rand_emo(){
    python3 -c "import random,re;EMO='🫀🫁🧠🦷🦴👀👁👅👄💋🩸🍏🍎🍐🍊🍋🍌🍉🍇🍓🫐🍈🍒🍑🥭🍍🥥🥝🍅🍆🥑🥦🥬🥒🌶🫑🌽🥕🫒🧄🧅🥔🍠🥐🥯🍞🥖🥨🧀🥚🧈🥞🧇🥓🥩🍗🍖🦴🌭🍔🍟🍕🫓🥪🥙🧆🌮🌯🫔🥗🥘🫕🥫🍝🍜🍲🍛🍣🍱🥟🦪🍤🍙🍚🍘🍥🥠🥮🍢🍡🍧🍨🍦🥧🧁🍰🎂🍮🍭🍬🍫🍿🍩🍪🥜🍯🥛🍼🫖☕️🍵🧃🥤🧋🍶🍺🍻🥂🍷🥃🍸🍹🍾🧊🥄🍴🍽🥣🥡🥢🧂🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷🐽🐸🐵🙈🙉🙊🐒🐔🐧🐦🐤🐣🐥🦆🦅🦉🦇🐺🐗🐴🦄🐝🪱🐛🦋🐌🐞🐜🪰🪲🪳🦟🦗🕷🕸🦂🐢🐍🦎🦖🦕🐙🦑🦐🦞🦀🐡🐠🐟🐬🐳🐋🦈🐊🐅🐆';print(random.choice(list(EMO.replace(' ', ''))), end='')"
}

# aggregate all history to the same .history file
shopt -s histappend
export PROMPT_COMMAND="history -a;history -c;history -r;$PROMPT_COMMAND"

# Alias definitions -- pulled from ~/.bash_aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# editor is vim
export VISUAL=vim
export EDITOR="$VISUAL"
set -o vi # can edit shell commands in vi

# pyenv in path
export PATH=$(pyenv root)/shims:$PATH

# git branch and status (credit: http://www.intridea.com/blog/2009/2/2/git-status-in-your-prompt)
function parse_git_dirty {
  if [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working tree clean" ]]; then
    # true - it's dirty
    return 0
  fi

  return 1
}

function print_git_dirty {
    parse_git_dirty && echo "*"
}

function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/(\1$(print_git_dirty))/"
}

fullprompt="maia: \[\033[32m\]\w\[\033[33m\] \$(parse_git_branch)\[\033[00m\] $(rand_emo)  "
export PS1="$fullprompt"
function promptoff {
    export PS1="\[\033[33m\]$\[\033[00m\] "
}
function prompton {
    export PS1="$fullprompt"
}

# git tab-completion
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# git delete branch -- delete the current branch and go to $MAIN_BRANCH
function gdb {
    branch=$(git rev-parse --abbrev-ref HEAD)

    if [ "$branch" == "$MAIN_BRANCH" ]; then
        echo "This is '$MAIN_BRANCH'. Nice try, buddy."
        return 1
    fi

    if [ "$branch" == "HEAD" ]; then
        echo "...but you're not on a branch."
        return 1
    fi

    if parse_git_dirty; then
        echo "You have uncomitted changes, won't delete branch."
        return 1
    fi

    echo "> Delete local branch '${branch}'? [Y/n]"
    read resp
    if !([ "${resp}" == "" ] || [ "${resp}" == "y" ] || [ "${resp}" == "Y" ]); then
        echo "OK, aborting."
        return 0
    fi

    git checkout $MAIN_BRANCH
    git branch -D ${branch}
    git pull origin $MAIN_BRANCH
}

# "update" -- switch to $MAIN_BRANCH and update
function upd {
    git checkout $MAIN_BRANCH && git pull origin $MAIN_BRANCH
}

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
venv() {
    if [ -f env/bin/activate ]; then
        source env/bin/activate
    elif [ -f bin/activate ]; then
        source bin/activate
    elif [ -f ~/.virtualenvs/${PWD##*/} ]; then
        source ~/.virtualenvs/${PWD##*/}
    else
        echo "No virtualenv 'activate' file found"
    fi
}

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

# "check" executes the subsequent command, and plays a good or bad sound
# according to the exit code
chk() {
    $*
    if [ $? -eq 0 ]
    then
      # success, good sound
      beep
    else
      # fail, bad sound
      dundundun
    fi
}

# Pretty print path
path() {
    echo $PATH | tr -s ':' '\n'
}

# "ls -t"/"ls time"/"last" -- ls of N most-recently-modified files (default 10)
lst() {
    # TODO don't display awkward first line
    # default num. files to display = 10
    n=10
    if [ "$1" -eq "$1" ] 2>/dev/null
    then
        # no path was passed, path is ".", this is num. files to display
        path="."
        n="$1"
    elif [ -z "$1" ]; then
        # no path OR numerical param., ls on "."
        path="."
    elif [ ! -z "$2" ]; then
        n="$2"
    fi
    ls -Atl $path | head -$n
}

# json-format the output of cURL command
jcurl() {
    curl "$@" | jq '.'
}

# run a command multiple times
# usage: `multi n echo hi`
function multi {
    n=$1
    shift

    for ((i = 0; i < $n; i++)); do "$@"; done
}

# compile the specified file with lilypond (and get systray notification
# of success or failure). (This could be a one-liner but I'm lazy.)
function lp {
    lilypond "$1"
    code=$?
    if [ $code -eq 0 ]; then
      terminal-notifier -message 'Lilypond success ✅'
    else
      terminal-notifier -message 'Lilypond failure ❌'
      return $code
    fi
}

# Add RVM to PATH for scripting.
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*


# local configs (source them last in case they override anything in here)
if [ -f ~/.bash_profile_local ]; then
    . ~/.bash_profile_local
fi

if [ -f ~/.bash_aliases_local ]; then
    . ~/.bash_aliases_local
fi


#### FIG ENV VARIABLES ####
# Please make sure this block is at the end of this file.
[ -s ~/.fig/fig.sh ] && source ~/.fig/fig.sh
#### END FIG ENV VARIABLES ####
