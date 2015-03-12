# Makefile for ~/.config/dotfiles
# Author: Maciej Delmanowski <drybjed@gmail.com>


# ---- Makefile options ----

# Get current directory
CURDIR			?= $(.CURDIR)

# If current user is the same as owner, do more things
OWNER			= drybjed

# Where dotfiles are kept
DOTFILES		= ~/.config/dotfiles

# Source of dotfiles
DOTFILES_GIT_URL	= https://github.com/${OWNER}/dotfiles

# Commands
LINK			= ln -snv
COPY			= cp -fv


# ---- dotfiles ----

GIT = ~/.gitconfig
GIT_OWNER = ~/.gitconfig.$(OWNER)

MUTT = ~/.muttrc ~/.muttrc.d

VIM = ~/.vimrc

ZSH = ~/.zsh ~/.zshenv ~/.zlogin ~/.zlogout ~/.zshrc

TMUX = ~/.tmux.conf

XRESOURCES = ~/.Xresources


SYMLINKS = $(VIM) $(ZSH) $(GIT) $(TMUX) $(MUTT) $(XRESOURCES)

OWNER_SYMLINKS = $(GIT_OWNER)


# ---- Main Makefile ----

all: install vim-vundle

install: git mutt tmux vim zsh mc gpg

owner: install vim-vundle gui smartcard newsbeuter

gui: xresources i3
	@ansible-playbook -i ansible/inventory ansible/playbooks/gui.yml

smartcard:
	@ansible-playbook -i ansible/inventory ansible/playbooks/gui.yml

vim: $(VIM)

zsh: $(ZSH)

git: $(GIT) $(GIT_OWNER)

mutt: $(MUTT) $(MUTT_OWNER)

tmux: $(TMUX)

xresources: $(XRESOURCES)

vim-vundle:
	@echo "Setting up vim bundles ... "
	@mkdir -p ~/.vim/bundle
	@test -d ~/.vim/bundle/vundle || \
		(git clone --quiet https://github.com/gmarik/vundle.git \
		~/.vim/bundle/vundle && \
		vim +BundleInstall +qall)

mc:
	@mkdir -p ~/.config/mc
	@test -e ~/.config/mc/ini || $(COPY) $(CURDIR)/.config/mc/ini ~/.config/mc/ini

gpg:
	@mkdir -m 700 -p ~/.gnupg
	@test -e ~/.gnupg/gpg.conf || $(LINK) $(CURDIR)/.gnupg/gpg.conf ~/.gnupg/gpg.conf

i3:
	@mkdir -p ~/.config
	@test -e ~/.config/i3 || \
		${LINK} $(CURDIR)/.config/i3 ~/.config/i3

newsbeuter:
	@mkdir -p ~/.local/share/newsbeuter
	@mkdir -p ~/.config/newsbeuter
	@test -e ~/.config/newsbeuter/config || \
		${LINK} $(CURDIR)/.config/newsbeuter/config ~/.config/newsbeuter/config
	@test ! -e ~/.config/newsbeuter/urls -a "${USER}" = "${OWNER}" && \
		${LINK} $(CURDIR)/.config/newsbeuter/urls ~/.config/newsbeuter/urls || true

get:
	@test ! -d ${DOTFILES} && git clone ${DOTFILES_GIT_URL} ${DOTFILES} || true

check-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -print

clean-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -delete

update:
	@git pull --rebase

$(SYMLINKS):
	@$(LINK) $(CURDIR)/$(patsubst $(HOME)/%,%,$@) $@

$(OWNER_SYMLINKS):
	@test "$(USER)" = "$(OWNER)" && (test -h $@ || $(LINK) $(CURDIR)/$(patsubst $(HOME)/%,%,$@) $@) || true

