#!/usr/bin/env bash

set -o errexit
set -o pipefail

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TMUX_THEME_SETTER="${CURRENT_DIR}/scripts/tmux_theme_mode.sh"

program_is_in_path() {
	local program="$1"
	type "$1" >/dev/null 2>&1
}

# Load Homebrew PATHs
if ! program_is_in_path brew; then
	echo "Could not find brew(1) in \$PATH" >&2
	exit 1
fi
eval "$(brew shellenv)"

if ! program_is_in_path dark-notify; then
	echo "Could not find dark-notify(1) in \$PATH" >&2
	exit 1
fi

# TODO while :; this?
echo dark-notify -c "$TMUX_THEME_SETTER"
