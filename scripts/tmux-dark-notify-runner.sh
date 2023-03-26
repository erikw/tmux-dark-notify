#!/usr/bin/env bash
# This script will run dark-notify(1) in a while loop (in case it would exit).

set -o errexit
set -o pipefail
[[ "${TRACE-0}" =~ ^1|t|y|true|yes$ ]] && set -o xtrace

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPT_NAME="$(basename $0)"
TMUX_THEME_SETTER="${CURRENT_DIR}/tmux-theme-mode.sh"

program_is_in_path() {
	local program="$1"
	type "$1" >/dev/null 2>&1
}

if pgrep -qf "$SCRIPT_NAME"; then
	echo "$SCRIPT_NAME is already running, nothing to do here."
	exit 0
fi

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

while :; do
	dark-notify -c "$TMUX_THEME_SETTER"
done
