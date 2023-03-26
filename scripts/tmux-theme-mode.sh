#!/usr/bin/env bash
# This script will source tmux themes depending on the argument light/dark.
# The dark/light theme paths should be configured in tmux user options (@-prefixed).

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
	tmux source "$theme_path"
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
