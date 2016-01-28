## .dotfiles

Here you can find a set of configuration files for various programs (zsh, vim,
apt, tmux, ...).  They are used on Debian GNU/Linux and mostly
work out of the box. You can use them both on your user and root accounts.

This version of my dotfiles is currently in its infancy, I'm planning to add
more things as I go. Stay tuned.

### Highlights

* prompt compatible with zsh prompt themes
* different shell prompts for regular users and root in zsh
* zsh recognizes git repositories and presents most important facts: branch
  name, weither repository is clean or dirty, are there any untracked files.
  You can also see the relative time of last commit (buggy, see TODO).
* 256 color environment is automatically recognized and set up

### Installation

Currently there is no install script. Just `git clone
https://github.com/drybjed/dotfiles.git` in a directory of your choice and symlink
files in your `$HOME` as needed. Some of these files, like those in `apt/`
directory should go elsewhere, for ex. `/etc/apt/`. YMMV.

### Thanks

Many parts of these dotfiles are not my work, here's a list of people who
wrote the code (or had it in their dotfiles) which you can find in this
repository. If you find your code without proper credit, let me know.

* GRML Team - http://grml.org/
* Joshua T. Corbin - https://github.com/jcorbin
* Wynn Netherland - https://github.com/pengwynn
