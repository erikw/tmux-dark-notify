#!/usr/bin/env bash
# This script will run dark-notify(1) in a while loop (in case it would exit).
# Each tmux server gets its own runner, tracked via a PID file keyed by the
# tmux socket path.

set -o errexit
set -o pipefail
[[ "${TRACE-0}" =~ ^1|t|y|true|yes$ ]] && set -o xtrace

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPT_NAME="$(basename "$0")"
TMUX_THEME_SETTER="${CURRENT_DIR}/tmux-theme-mode.sh"

program_is_in_path() {
	local program="$1"
	type "$program" >/dev/null 2>&1
}

# Per-server PID file based on the tmux socket path
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/tmux"
mkdir -p "$STATE_DIR"
TMUX_SOCKET="${TMUX%%,*}"
PID_FILE_KEY="$(md5 -qs "$TMUX_SOCKET")"
PID_FILE="${STATE_DIR}/tmux-dark-notify-${PID_FILE_KEY}.pid"

DARK_NOTIFY_PID=

cleanup() {
	rm -f "$PID_FILE"
	if [[ -n "$DARK_NOTIFY_PID" ]]; then
		kill "$DARK_NOTIFY_PID" 2>/dev/null || true
	fi
}

trap cleanup EXIT TERM HUP INT

# Check if another runner for this tmux server is already active
if [[ -f "$PID_FILE" ]]; then
	existing_pid="$(cat "$PID_FILE")"
	if kill -0 "$existing_pid" 2>/dev/null; then
		echo "$SCRIPT_NAME is already running for this tmux server (PID $existing_pid)."
		exit 0
	fi
	# Stale PID file, remove it
	rm -f "$PID_FILE"
fi

echo $$ > "$PID_FILE"

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
	dark-notify -c "$TMUX_THEME_SETTER" &
	DARK_NOTIFY_PID=$!
	wait "$DARK_NOTIFY_PID" || true
	DARK_NOTIFY_PID=
	sleep 1
done
