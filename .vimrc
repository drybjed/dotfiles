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

" Syntax highlighting and colors                {{{
if has ("syntax")

    " Dark background hack {{{2
    " This hack works on local terminal and over SSH (in Debian, by
    " default, ssh is passing $LC_* environment variables to the server,
    " so we can use it without much changes elsewhere)
    " To use this correctly, export a variable in your _local_ shell,
    " called LC_VIM_HACK_COLORFGBG with either 'dark' or 'light'
    " according to your preference. This variable will be passed to
    " subsequent shells and read by ViM.
    if exists('$LC_VIM_HACK_COLORFGBG')
        let g:myHackedBackground = $LC_VIM_HACK_COLORFGBG
        exec ':set background='.g:myHackedBackground
    endif " }}}2

    syntax on

    " Highlight unwanted spaces {{{2
    " http://vim.wikia.com/wiki/Highlight_unwanted_spaces
    highlight ExtraWhitespace ctermbg=red guibg=red
    autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red

    " Show trailing whitespace
    match ExtraWhitespace /\s\+$/

    " Show trailing whitepace and spaces before a tab
    match ExtraWhitespace /\s\+$\| \+\ze\t/

    " Show tabs that are not at the start of a line
    match ExtraWhitespace /[^\t]\zs\t\+/

    " Show spaces used for indenting (so you use only tabs for indenting)
    match ExtraWhitespace /^\t*\zs \+/

    " Highlight redundant whitespaces
    highlight ExtraWhitespace2 ctermbg=red guibg=red
    autocmd ColorScheme * highlight ExtraWhitespace2 ctermbg=red guibg=red
    match ExtraWhitespace2 /\s\+$\| \+\ze\t/
    " }}}2

    " Use darkburn colorscheme for dark backgrounds {{{
    if has("gui_running") || &t_Co >= 256 && &bg ==? "dark" && filereadable(expand("~/.vim/bundle/darkburn/colors/darkburn.vim"))
        colorscheme darkburn
    endif " }}}

endif " }}}

" Source a local configuration file if available		{{{
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

" Local configuration for specific user
if filereadable(expand("~/.vimrc." . $SUDO_USER))
    source ~/.vimrc.$SUDO_USER
endif       " }}}

" vim:foldenable:foldmethod=marker
