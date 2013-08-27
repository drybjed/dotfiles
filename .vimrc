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
    Bundle "nathanaelkane/vim-indent-guides"
    Bundle "Raimondi/YAIFA"
    Bundle 'tpope/vim-fugitive.git'
    Bundle 'jamessan/vim-gnupg'
    Bundle 'merlinrebrovic/focus.vim'
    Bundle 'mhinz/vim-signify'
    Bundle 'itchyny/lightline.vim'

    " github.com/vim-scripts repositories
    "Bundle "css_color.vim"
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

" General options                               {{{1
set nocompatible
set autoread
set noautowrite
set ruler
set showmode
set showcmd
set showmatch
set nostartofline
set modeline
set laststatus=2
set display+=lastline
set wildmode=list:longest,full
set wildmenu
set history=9999
set mouse=a
"set fillchars=vert:\ ,stl:\ ,stlnc:\ 
set hidden
set gdefault
set scrolloff=2
set cmdheight=2
set sessionoptions=blank,buffers,curdir,folds,help,options,resize,tabpages,winpos,winsize
set directory=.,~/tmp,/var/tmp
set viminfo='150,<1000,s100,r/tmp,r/mnt,r/media
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set textwidth=0
set wrap
set incsearch
set ignorecase
set smartcase
set hlsearch
"set listchars=tab:›\ ,trail:·,eol:¬
set formatoptions=1
set backspace=indent,eol,start
set autoindent
set smarttab
set noexpandtab
set tabstop=8
set softtabstop=0
set shiftwidth=8
set shiftround
set copyindent
set pastetoggle=<F6>

" Backups
set nobackup
set writebackup
set backupdir=.,./backup~,~/backup~
autocmd BufWritePre * let &bex = '-' . strftime("%Y%b%d%X") . '~'

" Text encoding                     {{{1
set printencoding=utf-8
set termencoding=utf-8
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=bom,utf-8,iso-8859-2,latin2,cp1250,default,latin1 " }}}1

" Beeping turned off
set noerrorbells visualbell t_vb=

" Toggleable current line highlighting {{{1
" Idea taken from Tobias Schlitt <toby@php.net> ~/.vimrc
" http://coderepos.org/share/browser/dotfiles/vim/kiske-vimrc?rev=33319#L65
if has ("syntax")
	let g:myCursorLine=0
	function! MyCursorLine()
		let g:myCursorLine = g:myCursorLine + 1
		if g:myCursorLine >= 3 | let g:myCursorLine = 0 | endif
		if g:myCursorLine == 1
			augroup myCursorLine
				autocmd!
				autocmd InsertEnter * set cursorline
				autocmd InsertLeave * set nocursorline
			augroup end
			echo "Cursor line on"
		elseif g:myCursorLine == 2
			augroup myCursorLine
				autocmd!
			augroup end
			set cursorline
			echo "Cursor line always"
		else
			augroup myCursorLine
				autocmd!
			augroup end
			set nocursorline
			echo "Cursor line off"
		endif
	endf

	nmap <F1> :call MyCursorLine()<CR>
	imap <F1> <C-o>:call MyCursorLine()<CR>
endif                                           " }}}1

" Auto commands					{{{1
if has ("autocmd")
	filetype plugin indent on

	" Jump to the last cursor position {{{2
	" http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
	autocmd BufReadPost *
	      \ if ! exists("g:leave_my_cursor_position_alone") |
	      \     if line("'\"") > 0 && line ("'\"") <= line("$") |
	      \         exe "normal g'\"" |
	      \     endif |
	      \ endif " }}}2

	" Email editing {{{2
	augroup mail
		autocmd!
		autocmd BufRead /tmp/mutt-* :silent! g/^>\ >/s//>>
		autocmd FileType mail set textwidth=78 | set wrap | set formatoptions=tcqron1
	augroup end " }}}2

	" Automatically set executable bit for scripts
	" http://www.reddit.com/r/linux/comments/e649x/
	function! ChmodScripts()
		if getline(1) =~ "^#!"
			if getline(1) =~ "/bin/"
				silent !chmod +x <afile>
			endif
		endif
	endf
	autocmd BufWritePost * call ChmodScripts()

endif					" }}}1

" Syntax highlighting and colors                {{{1
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

    " Use darkburn colorscheme for dark backgrounds {{{2
    if has("gui_running") || &t_Co >= 256 && &bg ==? "dark" && filereadable(expand("~/.vim/bundle/darkburn/colors/darkburn.vim"))
        colorscheme darkburn
    endif " }}}

endif " }}}

" Incerase/decrease ident of selected lines with < and > {{{1
" http://vim.wikia.com/wiki/Shifting_blocks_visually
vnoremap < <gv
vnoremap > >gv

" Move cursor by display lines when wrapping {{{1
" http://vim.wikia.com/wiki/Move_cursor_by_display_lines_when_wrapping
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk
vnoremap <Down> gj
vnoremap <Up> gk
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

" HTML/XHTML/PHP editing		{{{1
" Useful HTML shortcuts			{{{2
" http://stripey.com/vim/vimrc.html
" Only map these when entering an HTML file and unmap them on leaving it
autocmd BufEnter * if &filetype == "html" || &filetype == "xhtml" || &filetype == "php" | call MapHTMLKeys() | endif

" Sets up various insert mode key mappings suitable for typing HTML, and
" automatically removes them when switching to a non-HTML buffer
function! MapHTMLKeys(...)

	" ff no parameter, or a non-zero parameter, set up the mappings:
	if a:0 == 0 || a:1 != 0

		" require two backslashes to get one:
		inoremap \\ \

		" then use backslash followed by various symbols insert HTML characters:
		inoremap \& &amp;
		inoremap \< &lt;
		inoremap \> &gt;
		inoremap \. &middot;
		inoremap \o &deg;
		inoremap \2 &sup2;
		inoremap \3 &sup3;

		" em dash -- have \- always insert an em dash, and also have _ do it if
		" ever typed as a word on its own, but not in the middle of other words:
		inoremap \- &#8212;
		iabbrev _ &#8212;

		" hard space with <Ctrl>+Space, and \<Space> for when that doesn't work:
		inoremap \<Space> &nbsp;
		imap <C-Space> \<Space>

		" have the open and close single quote keys producing the character
		" codes that will produce nice curved quotes (and apostophes) on both Unix
		" and Windows:
		inoremap \` &#8216;
		inoremap \' &#8217;

		" when switching to a non-HTML buffer, automatically undo these mappings:
		augroup MapHTMLKeys
			autocmd!
			autocmd! BufLeave * call MapHTMLKeys(0)
		augroup end

	" parameter of zero, so want to unmap everything:
	else
		iunmap \\
		iunmap \&
		iunmap \<
		iunmap \>
		iunmap \.
		iunmap \o
		iunmap \2
		iunmap \3
		iunmap \-
		iunabbrev _
		iunmap \<Space>
		iunmap <C-Space>
		iunmap \`
		iunmap \'

		" once done, get rid of the autocmd that called this:
		augroup MapHTMLKeys
			autocmd!
		augroup end

	endif " test for mapping/unmapping

endfunction " MapHTMLKeys()

" GUI options		{{{1
if has('gui_running')
	set lines=50 columns=140 linespace=0
	set t_vb=
	set vb
	set noeb
	set guifont=Inconsolata\ 11
	set guioptions=aAci
	colorscheme darkburn
endif

" Source a local configuration file if available		{{{1
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

" Local configuration for specific user
if filereadable(expand("~/.vimrc." . $SUDO_USER))
    source ~/.vimrc.$SUDO_USER
endif       " }}}

" vim:foldenable:foldmethod=marker
