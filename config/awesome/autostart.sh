#!/usr//bin/env bash

function run() {
	if ! pgrep -f $1; then
		$@ &
	fi
}

# run "$HOME/.screenlayout/horizontalmonitorsetup.sh"
# run "syncthing --no-browser"
# run "$HOME/.screenlayout/verticalmonitorsetup.sh"
# run "telegram-desktop"
# run "dropbox"
# run "discord"
# run "picom"
# run "emacs --daemon --with-profile doomacs"
run "nm-applet"
run "blueberry-tray"
# run "barrier"
# run "devmon"
# run "unclutter &"
# run "$HOME/scripts/wallplaylist"
# run "cargo run --manifest-path=$HOME/code/rust/markust/Cargo.toml"

# run "volumeicon"
# run "zathura ~/dox/books/Komandnaia_stroka_Linux.pdf"
# run "rslsync"
# run "emacs"

# dwall -s firewatch3 &
# nitrogen --restore

# run "xinput --set-prop 'SINOWEALTH Wired Gaming Mouse' 'libinput Accel Speed' -0.8"
# run "setxkbmap -layout 'us, ru'"
# run "setxkbmap -option grp:caps_toggle"
# run "xrandr --output HDMI2 --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output VIRTUAL1 --off"
# wal -R
