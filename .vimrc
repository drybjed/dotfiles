" ~/.vimrc

" Vundle support				{{{
" http://github.com/gmarik/vundle
" Setup: git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
" vim: :BundleInstall

if filereadable(expand("~/.vim/bundle/vundle/autoload/vundle.vim"))
    set nocompatible
    filetype off  " required!

    set rtp+=~/.vim/bundle/vundle/ 
    call vundle#rc()

    " List of bundles {{{
    " github repositories
    Bundle "gmarik/vundle"
    Bundle "Raimondi/YAIFA"

    " github.com/vim-scripts repositories
    Bundle "css_color.vim"
    Bundle "darkburn"
    Bundle "dhcpd.vim"
    Bundle "EasyMotion"
    Bundle "interfaces"
    Bundle "nginx.vim"
    Bundle "openvpn"
    Bundle "snipMate"
    " }}}

endif " }}}

filetype plugin indent on

" Source a local configuration file if available		{{{
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

" Local configuration for specific user
if filereadable(expand("~/.vimrc." . $SUDO_USER))
    source ~/.vimrc.$SUDO_USER
endif       " }}}

" vim:foldenable:foldmethod=marker
