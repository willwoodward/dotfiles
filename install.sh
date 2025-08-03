#!/bin/bash

# Go to dotfiles directory
cd "$HOME/dotfiles" || exit 1

stow -t ~ bash zsh git tmux
stow -t ~/.config starship
