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

VIM = ~/.vimrc ~/.vim

ZSH = ~/.zsh ~/.zshenv ~/.zlogin ~/.zlogout ~/.zshrc

TMUX = ~/.tmux.conf

XRESOURCES = ~/.Xresources


SYMLINKS = $(VIM) $(ZSH) $(GIT) $(TMUX) $(MUTT) $(XRESOURCES)

OWNER_SYMLINKS = $(GIT_OWNER)


# ---- Main Makefile ----

all: install

install: get-depends git mutt tmux vim zsh mc gpg bin

get-depends:
	git submodule sync
	git submodule update --init --recursive

owner: install gui smartcard newsbeuter

gui: xresources i3 dunst
	@ansible-playbook -i ansible/inventory ansible/playbooks/gui.yml

smartcard:
	@ansible-playbook -i ansible/inventory ansible/playbooks/smartcard.yml

vim: $(VIM)

zsh: $(ZSH)

git: $(GIT) $(GIT_OWNER)

mutt: $(MUTT) $(MUTT_OWNER)

tmux: $(TMUX)

xresources: $(XRESOURCES)

mc:
	@mkdir -p ~/.config/mc
	@test -e ~/.config/mc/ini || $(COPY) $(CURDIR)/.config/mc/ini ~/.config/mc/ini

gpg:
	@mkdir -m 700 -p ~/.gnupg
	@test -e ~/.gnupg/gpg.conf || $(LINK) $(CURDIR)/.gnupg/gpg.conf ~/.gnupg/gpg.conf

bin:
	@mkdir -p ~/.local/bin
	@for i in $(CURDIR)/.local/bin/* ; do [ -e ~/.local/bin/$$(basename $$i) ] || ln -s $$(readlink -f $$i) ~/.local/bin/$$(basename $$i) ; done

i3:
	@mkdir -p ~/.config
	@test -e ~/.config/i3 || \
		${LINK} $(CURDIR)/.config/i3 ~/.config/i3

dunst:
	@mkdir -p ~/.config
	@test -e ~/.config/dunst || \
		${LINK} $(CURDIR)/.config/dunst ~/.config/dunst

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
