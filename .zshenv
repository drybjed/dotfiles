# ~/.zshenv

if [ -f $HOME/.profile ]; then
	. $HOME/.profile
fi

fpath=($HOME/.zsh/functions $fpath)
typeset -U fpath

if [ -f $HOME/.zshenv.local ]; then
	. $HOME/.zshenv.local
fi

