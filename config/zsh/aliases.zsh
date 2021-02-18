alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

alias q=exit
alias clr=clear
alias sudo='sudo '
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias wget='wget -c'

alias mk=make
alias rcp='rsync -vaP --delete'
alias rmirror='rsync -rtvu --delete'
alias gurl='curl --compressed'
alias rr='curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'

alias redditWall='node $HOME/scripts/nodeRedditDownloader/wallpaperDownloader -d -t day -p new -l 100 -mw 1920 -mh 1080 -s'

alias y='xclip -selection clipboard -in'
alias p='xclip -selection clipboard -out'

alias ss='sudo systemctl'
alias ka='killall'

if command -v exa >/dev/null; then
	alias exa="exa --group-directories-first"
	alias ls='exa -al --color=always --group-directories-first'
	alias la='exa -a --color=always --group-directories-first'
	alias ll='exa -l --color=always --group-directories-first'
	alias lt='exa -aT --color=always --group-directories-first'
fi

if command -v youtube-dl >/dev/null; then
	alias ytv='youtube-dl -o "~/vids/%(title)s.%(ext)s"'                       #Download video link
	alias yta='youtube-dl -o "~/musx/%(title)s.%(ext)s" -x --audio-format mp3' #Download only audio
fi

autoload -U zmv

take() {
	mkdir "$1" && cd "$1"
}
compdef take=mkdir

zman() {
	PAGER="less -g -I -s '+/^       "$1"'" man zshall
}

r() {
	local time=$1
	shift
	sched "$time" "notify-send --urgency=critical 'Reminder' '$@'; ding"
}
compdef r=sched
