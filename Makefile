# Makefile for ~/.config/dotfiles
# Author: Maciej Delmanowski <drybjed@gmail.com>

# Get current directory
CURDIR ?= $(.CURDIR)

# If current user is the same as owner, do more things
OWNER = drybjed

# Where dotfiles are kept
DOTFILES = ~/.config/dotfiles

# Source of dotfiles
DOTFILES_GIT_URL = https://github.com/${OWNER}/dotfiles

# Commands
LINK = ln -sfn
COPY = cp -f

# Colors
COLOR = \033[32;01m
NO_COLOR = \033[0m

help:
	@echo "Makefile for installing dotfiles"
	@echo
	@echo "Create symlinks:"
	@echo "   $(COLOR)make install$(NO_COLOR)		Install symlinks"
	@echo
	@echo "Install vim bundles:"
	@echo "   $(COLOR)make vim-vundle$(NO_COLOR)	Install vim bundles"
	@echo
	@echo "Maintenance:"
	@echo "   $(COLOR)make get$(NO_COLOR)		git clone dotfiles in ~/.dotfiles/"
	@echo "   $(COLOR)make check-dead$(NO_COLOR)	Print dead symlinks"
	@echo "   $(COLOR)make clean-dead$(NO_COLOR)	Delete dead symlinks"
	@echo "   $(COLOR)make update$(NO_COLOR)		Alias for git pull --rebase"
	@echo
	@echo "Useful aliases:"
	@echo "   $(COLOR)make all$(NO_COLOR)		install vim-vundle"

all: install vim-vundle

install: git mutt tmux vim zsh mc gpg newsbeuter

git:
	@echo "Configuring git ..."
	@test ! -e ~/.gitconfig && ${LINK} $(CURDIR)/.gitconfig ~/.gitconfig || true
	@test ! -e ~/.gitconfig.${OWNER} -a "${USER}" = "${OWNER}" && \
		${LINK} $(CURDIR)/.gitconfig.${OWNER} ~/.gitconfig.${OWNER} || true

mutt:
	@echo "Configuring mutt ..."
	@test ! -e ~/.muttrc.d && ${LINK} $(CURDIR)/.muttrc.d ~/.muttrc.d || true
	@test ! -e ~/.muttrc && ${LINK} $(CURDIR)/.muttrc ~/.muttrc || true
	@test ! -e ~/.muttrc.${OWNER} -a "${USER}" = "${OWNER}" -a -e $(CURDIR)/.muttrc.${OWNER} && \
		${LINK} $(CURDIR)/.muttrc.${OWNER} ~/.muttrc.${OWNER} || true

tmux:
	@echo "Configuring tmux ..."
	@test ! -e ~/.tmux.conf && ${LINK} $(CURDIR)/.tmux.conf ~/.tmux.conf || true

vim:
	@echo "Configuring vim ..."
	@test ! -e ~/.vimrc && ${LINK} $(CURDIR)/.vimrc ~/.vimrc || true

vim-vundle:
	@echo "Setting up vim bundles ... "
	@mkdir -p ~/.vim/bundle
	@test -d ~/.vim/bundle/vundle || \
		(git clone --quiet https://github.com/gmarik/vundle.git \
		~/.vim/bundle/vundle && \
		vim +BundleInstall +qall)

zsh:
	@echo "Configuring zsh ..."
	@test ! -d ~/.zsh && ${LINK} $(CURDIR)/.zsh ~/.zsh || true
	@test ! -e ~/.zshenv && ${LINK} $(CURDIR)/.zshenv ~/.zshenv || true
	@test ! -e ~/.zlogin && ${LINK} $(CURDIR)/.zlogin ~/.zlogin || true
	@test ! -e ~/.zshrc && ${LINK} $(CURDIR)/.zshrc ~/.zshrc || true

mc:
	@echo "Configuring mc ..."
	@mkdir -p ~/.config/mc
	@test ! -e ~/.config/mc/ini && ${COPY} $(CURDIR)/.config/mc/ini ~/.config/mc/ini || true

gpg:
	@echo "Configuring gpg ..."
	@mkdir -m 700 -p ~/.gnupg
	@test ! -e ~/.gnupg/gpg.conf && ${LINK} $(CURDIR)/.gnupg/gpg.conf ~/.gnupg/gpg.conf || true

newsbeuter:
	@echo "Configuring newsbeuter ..."
	@mkdir -p ~/.local/share/newsbeuter
	@mkdir -p ~/.config/newsbeuter
	@test ! -e ~/.config/newsbeuter/config && \
		${LINK} $(CURDIR)/.config/newsbeuter/config ~/.config/newsbeuter/config || true
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

