#!/usr/bin/env bash
# Requirements: brew install dark-notify

set -o errexit
set -o pipefail
[[ "${TRACE-0}" =~ ^1|t|y|true|yes$ ]] && set -o xtrace

SCRIPT_NAME=${0##*/}
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR"

IFS= read -rd '' USAGE <<EOF || :
Set tmux dark/light mode.
Usage: $ ${SCRIPT_NAME} light|dark
EOF



TMUX_STATED=${XDG_STATE_HOME:-$HOME/.local/state}/tmux
! [ -d $TMUX_STATED ] && mkdir -p $TMUX_STATED
TMUX_THEME_LINK=$TMUX_STATED/tmux-theme-mode.conf

tmux_set_theme_mode() {
	local mode="$1"

	if [ "$mode" =  dark ]; then
		theme_conf=$HOME/.repos/tmux-colors-solarized/tmuxcolors-dark.conf
	else
		theme_conf=$HOME/.repos/tmux-colors-solarized/tmuxcolors-light.conf
	fi
	tmux source $theme_conf
	ln -sf $theme_conf $TMUX_THEME_LINK
}


mode=
while getopts ":c:h?" opt; do
	case "$opt" in
		:) echo "Option -$OPTARG requires an argument." >&2; exit 1;;
		h|?|*) echo -e "$USAGE"; exit 0;;
	esac
done
shift $(($OPTIND - 1))

mode="$1"
if [[ -z "$mode" ]]; then
	echo "Missing required argument 'mode'." >&2
	exit 1
elif [[ "$mode" != light ]] && [[ "$1" != dark ]]; then
	echo "Mode must be 'light' or 'dark'." >&2
	exit 2
fi

tmux_set_theme_mode "$mode"
