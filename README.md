# tmux-dark-notify - Make tmux's theme follow macOS dark/light mode 
[![Top programming languages used](https://img.shields.io/github/languages/top/erikw/tmux-dark-notify)](#)
[![SLOC](https://img.shields.io/tokei/lines/github/erikw/tmux-dark-notify?logo=codefactor&logoColor=lightgrey)](#)
[![License](https://img.shields.io/github/license/erikw/tmux-dark-notify?color=informational)](LICENSE.txt)
[![OSS Lifecycle](https://img.shields.io/osslifecycle/erikw/tmux-dark-notify)](https://github.com/Netflix/osstracker)
[![Latest tag](https://img.shields.io/github/v/tag/erikw/tmux-dark-notify)](https://github.com/erikw/tmux-powerline/tags)

This tmux [tpm](https://github.com/tmux-plugins/tpm) plugin will change the tmux theme automatically when the system changes the light/dark mode. Configure a light and a dark theme and the plugin will take care of the rest!

![Demo of changing system theme](demo.gif)


For example I use a Solarized in all my programs that support it. For tmux I use [seebi/tmux-colors-solarized](https://github.com/seebi/tmux-colors-solarized) which is locally cloed (in my dotfiles as a submodule). This tmux theme repo provides a light theme `tmuxcolors-light.conf` and a dark theme `tmuxcolors-dark.conf`. With this tmux plugin, I have configured so that when the system appearance mode changes, the corresponding tmux theme will be used.

Hats off to [dark-notify](https://github.com/cormacrelf/dark-notify) which this plugin is built up on!

# Setup
## Requirements
* macOS - [dark-notify](https://github.com/cormacrelf/dark-notify) is only for mac
* Bash
* Homebrew
* [dark-notify](https://github.com/cormacrelf/dark-notify): `$ brew install dark-notify`
* tmux
* [tpm](https://github.com/tmux-plugins/tpm) - Tmux Plugin Manager

## Setup steps
1. Make sure all requirements above are installed and working already.
2. Configure tmux-dark-notify in `tmux.conf`
   * To install the plugin, add a line 
     ```conf
      set -g @plugin 'erikw/tmux-dark-notify'
     ```
   * Now you must configure the paths for the light/dark themes you want to use. I personally have [seebi/tmux-colors-solarized](https://github.com/seebi/tmux-colors-solarized) cloned to `~/.repos/tmux-colors-solarized/`. Change the paths below to your themes.
     ```conf
     set -g @dark-notify-theme-path-light '$HOME/.repos/tmux-colors-solarized/tmuxcolors-light.conf'
     set -g @dark-notify-theme-path-dark '$HOME/.repos/tmux-colors-solarized/tmuxcolors-dark.conf'
     ```
   * To cover some corner cases e.g. if you use the plugin [tmux-reset](https://github.com/hallazzang/tmux-reset), I recommend adding this explicit source of the theme as well as a fallback in case this plugin is not run in all scenarios. The `if-shell` condition is there because the symlink won't be there the very first time until tmux-dark-notify has run. **Remove any other** `source-file` for theme you have of course!
     ```conf
     if-shell "test -e ~/.local/state/tmux/tmux-dark-notify-theme.conf" \
	      "source-file ~/.local/state/tmux/tmux-dark-notify-theme.conf"
     ```
   * Thus in summary, the relevant section of you `tmux.conf` could look like:
     ```conf
     set -g @plugin 'erikw/tmux-dark-notify'
     set -g @dark-notify-theme-path-light '$HOME/.repos/tmux-colors-solarized/tmuxcolors-light.conf'
     set -g @dark-notify-theme-path-dark '$HOME/.repos/tmux-colors-solarized/tmuxcolors-dark.conf'
     if-shell "test -e ~/.local/state/tmux/tmux-dark-notify-theme.conf" \
	      "source-file ~/.local/state/tmux/tmux-dark-notify-theme.conf"
     ```
3. Install the plugin with `<prefix>I`, unless you changed [tpm's keybindings](https://github.com/tmux-plugins/tpm#key-bindings).
4. Try toggle the system's appearance mode from System Settings and see that the tmux theme is changing
   * To verify, you can `ls -l ~/.local/state/tmux/tmux-dark-notify-theme.conf` to see that it is linked to the light or dark theme you configured.



# Tips on more light/dark mode configuration
* NeoVim: set up [dark-notify](https://github.com/cormacrelf/dark-notify) to change our nvim theme as well!
* [iTerm2](https://iterm2.com/downloads.html): Use version >=3.5 (currently in beta) as it has support for automatically changing the whole terminal theme between light/dark when the system appearance mode changes. This is what I have in the demo GIF at the top of this file.
  * Go to iTerm2 Preferences > Profiles > your profile > Colors (tab):
    * Check the "Use different colors for light and dark mode"
    * Under "Editing:", chose your light and dark colors (tip: usee the color presets button).
* Global keyboard shortcut: Create a global keyboard shortcut to toggle mode in macOS.
  * Open Automator.app
    * Create a new `Quick Action`.
    * Drag from the list to the left the  "Change System Appearace" to the areaon the rnage, and set "Change Appearance" to "Toggle Light/Dark".
    * Save it e.g. as `apperance_toggle`.
  * Open System Settings > Keyboard > Keyboard shortcuts (button) > Services
    * Find the `apperance_toggle` service we just created under the General category
    * Bind it to a shortcut e.g.  CTRL+OPT+CMD+t (this shortcut was used when feature first appeared in a beta version of macOS).


# More tmux plugins
I have another tmux plugin that might interest you:
* [tmux-powerline](https://github.com/erikw/tmux-powerline) - A tmux plugin giving you a hackable status bar consisting of dynamic & beautiful looking powerline segments, written purely in bash.
