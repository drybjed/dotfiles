# ~/.zshrc

if ! find /etc/profile.d/ -maxdepth 0 -empty | read v; then
	for part in /etc/profile.d/*; do
		source $part
	done
fi

for part in $HOME/.zsh/rc.d/??_*; do
	source $part
done

if [ -r $HOME/.zshrc.local ]; then
	source $HOME/.zshrc.local
fi

if [ -r $HOME/.zshrc.$SUDO_USER ]; then
	source $HOME/.zshrc.$SUDO_USER
fi

