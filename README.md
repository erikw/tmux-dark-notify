# tmux-dark-notify - Make tmux's color follow macOS dark/light mode 
[![SLOC](https://img.shields.io/tokei/lines/github/erikw/tmux-dark-notify?logo=codefactor&logoColor=lightgrey)](#)
[![License](https://img.shields.io/github/license/erikw/tmux-dark-notify?color=informational)](LICENSE.txt)
[![OSS Lifecycle](https://img.shields.io/osslifecycle/erikw/tmux-dark-notify)](https://github.com/Netflix/osstracker)

This tmux plugin will change the tmux theme automatically when the system changes the light/dark mode. Configure a light and a dark theme and the plugin will take care of the rest!

![Demo of changing system theme](demo.gif)


For example I use a Solarized in all my programs and for tmux I use [seebi/tmux-colors-solarized](https://github.com/seebi/tmux-colors-solarized). I have a local clone of this repo (in my dotfiles as a submodule). This repo provides a light theme `tmuxcolors-light.conf` and a dark theme `tmuxcolors-dark.conf`. With this tmux plugin, I have configured so that when the system appearance mode changes, the corresponding tmux theme will be used.

## Requirements
* Bash
* Homebrew
* dark-notify


# Tips on more light/dark configuration
* dark-notify vim
* iTerm 3.5
* global toggle shortcut


# TODOs
* git tag
