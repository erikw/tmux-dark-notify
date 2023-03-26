#!/usr/bin/env bash
touch /tmp/tmux-dark-run-runner.tmux
#set -xi
#exec 2>/tmp/tmux-dark-notify.log

log_path="/tmp"
log_file="${log_path}/tmux-dark-notify.log"
exec >  >(tee -a "$log_file")
exec 2> >(tee -a "$log_file" >&2)
set -x

set -o errexit
set -o pipefail

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
