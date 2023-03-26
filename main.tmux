#!/usr/bin/env bash

touch /tmp/tmux-dark-run-main.tmux
#set -xi
#exec 2>/tmp/tmux-dark-notify.log

set -o errexit
set -o pipefail

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
RUNNER="${CURRENT_DIR}/scripts/tmux-dark-notify-runner.sh"

$RUNNER &
