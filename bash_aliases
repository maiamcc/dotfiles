### GENERAL THINGS ###

# git, my git!
alias g='git'
alias gacm='git add -A && git commit -m'
alias gaca='git add -A && git commit --amend --no-edit'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
export LSCOLORS="Gxfxcxdxbxegedabagacad"
alias ls='LC_COLLATE=C ls -F -G'
alias ll='ls -lashF'
alias la='ls -A'
alias l='ls -CF'

# look at file at a git hash
alias glook='git cat-file -p'

# search for processes by name
alias procs="ps -ef | grep"

# play a sound
alias sound='afplay /System/Library/Sounds/Ping.aiff'

# open all config files
alias config='subl ~/.bash_profile ~/.bash_aliases ~/.work_profile ~/.work_aliases ~/.gitconfig'

# source bash profile
alias src='source ~/.bash_profile'

# commit as a wip
alias wip='g a && g cm "wip"'

# ...and check out master
alias wipco='g a && g cm "wip" && g co master'

# commit current work as wip, update master, switch back to old branch and rebase
alias rebm='wipco && g pullom && g co - && g rebasem && g reset head~'

# url encode and decode
alias urlenc='urlencode'
alias urldec='urldecode'

# copy a safety pig to your clipboard
alias pig='safetypig'
