# ~/.zshrc

for part in $HOME/.zsh/rc.d/??_*; do
	source $part
done

[ -f $HOME/.zshrc.$SUDO_USER ] && source $HOME/.zshrc.$SUDO_USER

