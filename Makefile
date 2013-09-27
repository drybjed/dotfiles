CURDIR ?= $(.CURDIR)

LN_FLAGS = -sfn

.PHONY: .tmux.conf .vimrc .zsh .zshenv .zshenv.local .zlogin .zshrc vim-vundle dark mc-ini

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

install: .tmux.conf .vimrc .zsh .zshenv .zlogin .zshrc mc-ini

dark: .zshenv.local

.tmux.conf:
	@echo "Symlinking ~/$@"
	@test ! -e ~/$@ && ln $(LN_FLAGS) $(CURDIR)/$@ ~/$@

.vimrc:
	@echo "Symlinking ~/$@"
	@test ! -e ~/$@ && ln $(LN_FLAGS) $(CURDIR)/$@ ~/$@

.zsh:
	@echo "Symlinking ~/$@"
	@test ! -e ~/$@ && ln $(LN_FLAGS) $(CURDIR)/$@ ~/$@

.zshenv:
	@echo "Symlinking ~/$@"
	@test ! -e ~/$@ && ln $(LN_FLAGS) $(CURDIR)/$@ ~/$@

.zshenv.local:
	@echo "Symlinking ~/$@"
	@test ! -e ~/$@ && ln $(LN_FLAGS) $(CURDIR)/$@ ~/$@

.zlogin:
	@echo "Symlinking ~/$@"
	@test ! -e ~/$@ && ln $(LN_FLAGS) $(CURDIR)/$@ ~/$@

.zshrc:
	@echo "Symlinking ~/$@"
	@test ! -e ~/$@ && ln $(LN_FLAGS) $(CURDIR)/$@ ~/$@

vim-vundle:
	@echo "Setting up vim bundles ... "
	@mkdir -p ~/.vim/bundle
	@test -d ~/.vim/bundle/vundle || \
		(git clone --quiet https://github.com/gmarik/vundle.git \
		~/.vim/bundle/vundle && \
		vim +BundleInstall +qall)

mc-ini:
	@echo "Copying ~/.config/mc/ini"
	@test ! -e ~/.config/mc/ini && cp $(CURDIR)/.config/mc/ini ~/.config/mc/ini

get:
	@test ! -d ~/.dotfiles && git clone --quiet git://github.com/drybjed/dotfiles.git ~/.dotfiles/

check-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -print

clean-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -delete

update:
	git pull --rebase

