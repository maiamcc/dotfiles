### GENERAL THINGS ###

# git, my git!
[ -f ~/.git-completion.bash ] && . ~/.git-completion.bash
alias g='git'
__git_complete g _git # autocomplete for the alias
alias gacm='git add -A && git commit -m'
alias gaca='git add -A && git commit --amend --no-edit'
alias grebcont='git add -A && git rebase --continue' # continue rebase
alias rmunt='git ls-files --others --exclude-standard | xargs rm -rf' # remove untracked
alias upd="git checkout $MAIN_BRANCH && git pull origin $MAIN_BRANCH" # switch to $MAIN_BRANCH and update

# open modified files as returned by 'git status'
alias stopen='for fn in $(git status --porcelain | awk '"'"'{print $2}'"'"'); do subl "$fn"; done'

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
alias grep='grep --color=auto'

# some more ls aliases
export LSCOLORS="Gxfxcxdxbxegedabagacad"
alias ls='CLICOLOR_FORCE=true LC_COLLATE=C ls -F -G'
alias ll='ls -lashF'
alias la='ls -A'
alias l='ls -CF'
# see bash_profile for lst (last 10 modified files)

# search for processes by name
alias procs="ps -ef | grep"

# open all config files
alias config='subl ~/.bash_profile ~/.bash_aliases ~/.bash_profile_local ~/.bash_aliases_local ~/.gitconfig ~/.gitconfig_local'

# restart the shell (and load any changes to bash_profile etc.)
# keeping this as "src" b/c that's what I'm used to typing (used to stand for
# "source bash profile")
alias src='exec -l $SHELL'

# commit as a wip
alias wip='g a && g cm "wip"'

# ...and check out $MAIN_BRANCH
alias wipco='g a && g cm "wip" && g co $MAIN_BRANCH'

# commit current work as wip, update $MAIN_BRANCH, switch back to old branch and rebase
alias rebm='wipco && g pullom && g co - && g rebasem && g reset head~'

# url encode and decode
alias urlenc='urlencode'
alias urldec='urldecode'

# copy a safety pig to your clipboard
alias pig='safetypig'

# restart clipboard if it's being a jerk
alias restclip='launchctl stop com.apple.pboard && launchctl start com.apple.pboard'

# run Python SimpleHTTPServer
alias pyserv='python -m SimpleHTTPServer'

alias bp='bpython'

# give me an animal making a real dumb joke
# requires:
#   - `brew install cowsay`
#   - `brew install coreutils` (for gshuf)
alias punme='gshuf -n1 ~/.punlist | cowsay -f $(ls /usr/local/share/cows/ | gshuf -n1)'

# play the apathy beep
alias beep='afplay ~/.ApathyBeep.aif'

# play dramatic music
alias dundundun='afplay ~/.DunDunDun.aiff'

# terminal notifier
alias notif="terminal-notifier -message"

# exit code of previous command
alias prev='echo $?'

alias yeet='rm -rf'