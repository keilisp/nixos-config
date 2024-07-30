#!/usr//bin/env bash

function run() {
	if ! pgrep -f $1; then
		$@ &
	fi
}

# TODO export to nix what possible
run "emacs --daemon"
run "nm-applet"
run "blueberry-tray"
# run "$HOME/scripts/nodeRedditDownloader/wallpaperDownloader -d -t day -p new -mw 1920 -mh 1080 -s Animewallpaper"
run "wallplaylist"
run "telegram-desktop"
# run "Discord"
# run "dropbox"
run "udiskie"
run "unclutter &"

# run "$HOME/.screenlayout/horizontalmonitorsetup.sh"
# run "syncthing --no-browser"
# run "$HOME/.screenlayout/verticalmonitorsetup.sh"
# run "discord"
# run "emacs --daemon --with-profile doomacs"
# run "barrier"
# run "devmon"
# run "cargo run --manifest-path=$HOME/code/rust/markust/Cargo.toml"
# run "volumeicon"
# run "emacs"
# run "xinput --set-prop 'SINOWEALTH Wired Gaming Mouse' 'libinput Accel Speed' -0.8"
# run "setxkbmap -layout 'us, ru'"
# run "setxkbmap -option grp:caps_toggle"
