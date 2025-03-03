#!/usr/bin/env bash
# Devcontainer postCreateCommand.
# Install dependencies for running this project in GitHub Codespaces.

set -eux

# Defensive (aggressive?) sysop: in case user's dotfiles installed tmux configs already.
# NOTE unfortunately there is not devcontainer command that runs after the setup of dotfiles. So these rm's might not have the intended effect... Just run this script manually once if you happen to have any own tmux confs installed via dotfiles in your Codespaces. Ref: https://containers.dev/implementors/json_reference/#lifecycle-scripts
## Tmux
rm -rf "${XDG_CONFIG_HOME:-$HOME/.config}"/tmux
rm -rf "$HOME"/.tmux


# Set up TPM. Ref: https://github.com/tmux-plugins/tpm?#installation
git clone https://github.com/tmux-plugins/tpm "$HOME"/.tmux/plugins/tpm

cat << TMUXCONF > "$HOME"/.tmux.conf
# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'seebi/tmux-colors-solarized'
# Install tmux-dark-notify as a "local plugin". Ref: https://github.com/tmux-plugins/tpm/issues/220#issuecomment-1082686994
run '/workspaces/tmux-dark-notify/main.tmux'

# Plugin options
set -g @dark-notify-theme-path-light '$HOME/.tmux/plugins/tmux-colors-solarized/tmuxcolors-light.conf'
set -g @dark-notify-theme-path-dark '$HOME/.tmux/plugins/tmux-colors-solarized/tmuxcolors-dark.conf'

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
TMUXCONF

# Install TPM plugins
"$HOME"/.tmux/plugins/tpm/bin/install_plugins