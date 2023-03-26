#!/usr/bin/env bash
# This script will set the tmux theme in use by rewriting a symlink and then sourcing the theme.
# The dark/light theme paths should be configured in tmux user options (@-prefixed).
#
# Why write symlink and not just source? Because if tmux.conf uses the tmux-clear plugin and tmux.conf is resourced, then this plugin might not load. Then it's convenient to also have a "tmux source-file path/to/the/symlink-theme.conf" so that the right theme is still loaded.

set -o errexit
set -o pipefail
[[ "${TRACE-0}" =~ ^1|t|y|true|yes$ ]] && set -o xtrace

SCRIPT_NAME=${0##*/}
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR"

OPTION_THEME_LIGHT="@dark-notify-theme-path-light"
OPTION_THEME_DARK="@dark-notify-theme-path-dark"

IFS= read -rd '' USAGE <<EOF || :
Set tmux dark/light mode.
Usage: $ ${SCRIPT_NAME} light|dark
EOF



TMUX_STATED=${XDG_STATE_HOME:-$HOME/.local/state}/tmux
! [ -d $TMUX_STATED ] && mkdir -p $TMUX_STATED
TMUX_THEME_LINK=$TMUX_STATED/tmux-dark-notify-theme.conf

tmux_get_option() {
	local option=$1
	local opt_val=$(tmux show-option -gqv "$option")
	if [ -z "$opt_val" ]; then
		echo "Required tmux plugin option '$option' not set!" >&2
		exit 1
	fi
	echo $opt_val
}

tmux_set_theme_mode() {
	local mode="$1"

	if [ "$mode" = dark ]; then
		theme_path=$(tmux_get_option $OPTION_THEME_DARK)
	else
		theme_path=$(tmux_get_option $OPTION_THEME_LIGHT)
	fi
	# Expand e.g. $HOME
	theme_path=$(eval echo "$theme_path")
	if [ ! -r "$theme_path" ]; then
		echo "The configured theme is not readable: $theme_path" >&2
		exit 2
	fi
	tmux source-file "$theme_path"
	ln -sf "$theme_path" $TMUX_THEME_LINK
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
