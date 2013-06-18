#!/bin/bash

# dotfiles deployment script

repository="git://github.com/drybjed/dotfiles"
repodir="$HOME/.Vault/github.com/drybjed"
dotdir="$HOME/.Vault/github.com/drybjed/dotfiles"

mkdir -p $repodir
cd $repodir
git clone $repository

ln -s $dotdir/.zsh $HOME/.zsh
ln -s $dotdir/.zlogin $HOME/.zlogin
ln -s $dotdir/.zshenv $HOME/.zshenv
ln -s $dotdir/.zshrc $HOME/.zshrc
ln -s $dotdir/.vimrc $HOME/.vimrc
ln -s $dotdir/.tmux.conf $HOME/.tmux.conf

if [[ "$1" = "dark" ]]; then
	ln -s $dotdir/.zshenv.local $HOME/.zshenv.local
fi

