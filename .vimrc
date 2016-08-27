" ~/.vimrc

" Check if we are in a restricted mode
silent! call writefile([], '')
" In restricted mode, this fails with E145: Shell commands not allowed in rvim
" In non-restricted mode, this fails with E482: Can't create file <empty>
let isRestricted = (v:errmsg =~# '^E145:')

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

    if ! isRestricted
        Bundle 'mhinz/vim-signify'
        Bundle 'itchyny/lightline.vim'
    endif

    Bundle 'mattn/webapi-vim'
    Bundle 'mattn/gist-vim'
    Bundle 'stephpy/vim-yaml'
    Bundle 'chase/vim-ansible-yaml'
    Bundle 'plasticboy/vim-markdown'
    Bundle 'Rykka/riv.vim'
    Bundle 'wannesm/wmgraphviz.vim'
    Bundle "kien/ctrlp.vim"
    Bundle "scrooloose/nerdtree"
    Bundle "dhruvasagar/vim-vinegar"

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
set noshowmode
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
set cmdheight=1
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

if isRestricted
    set showmode
endif

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

" Folds {{{1
" Open/Close folds with Space in normal mode
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>

" Create new fold with foldmethod=manual
vnoremap <Space> zf

" Incerase/decrease ident of selected lines with < and > {{{1
" http://vim.wikia.com/wiki/Shifting_blocks_visually
vnoremap < <gv
vnoremap > >gv

" Settings for vim-markdown {{{1
let g:vim_markdown_folding_disabled=1

" Open *.md files in a web browser - use with Markdown Reader extension:
" https://chrome.google.com/webstore/detail/markdown-reader/gpoigdifkoadgajcincpilkjmejcaanc
autocmd BufEnter *.md exec 'noremap <Leader>c :!x-www-browser %:p<CR><CR>'


" Settings for vim-gnupg {{{1
let g:GPGPreferArmor=1
let g:GPGPreferSign=1

" Settings for reStructuredText {{{1
" Send current document to local web browser
" rst2html index.rst | base64 -w 0 | xargs -i x-www-browser "data:text/html;charset=utf8;base64,{}"
autocmd BufEnter *.rst exec 'noremap <Leader>c :!rst2html %:p \| base64 -w 0 \| xargs -i x-www-browser "data:text/html;charset=utf8;base64,{}"<CR><CR>'

" Disable fricking folding in .rst files
let g:riv_disable_folding=1
let g:riv_fold_auto_update=0

" Settings for ctrlp {{{1
let g:ctrlp_follow_symlinks=1
let g:ctrlp_custom_ignore = {
	\ 'dir':  '\v[\/]\.(git|hg|svn)$',
	\ 'file': '\v\.(pyc)$',
	\ }

" Split navigation {{{1
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Better split ordering {{{1
set splitbelow
set splitright

" System clipboard integration {{{1
" Yank selection to system clipboard
noremap <Leader>y "*y

" Yank current line to system clipboard
noremap <Leader>yy "*Y

" Paste text from system clipboard
noremap <Leader>p :set paste<CR>"*p<Esc>:set nopaste<CR>


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

" Better security practices
" http://blog.sanctum.geek.nz/linux-crypto-passwords/
"
" Prevent various Vim features from keeping the contents of pass(1) password
" files (or any other purely temporary files) in plaintext on the system.
"
" Either append this to the end of your .vimrc, or install it as a plugin with
" a plugin manager like Tim Pope's Pathogen.
"
" Author: Tom Ryder <tom@sanctum.geek.nz>
"

" Don't backup files in temp directories or shm
if exists('&backupskip')
    set backupskip+=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
endif

" Don't keep swap files in temp directories or shm
if has('autocmd')
    augroup swapskip
        autocmd!
        silent! autocmd BufNewFile,BufReadPre
            \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
            \ setlocal noswapfile
    augroup END
endif

" Don't keep undo files in temp directories or shm
if has('persistent_undo') && has('autocmd')
    augroup undoskip
        autocmd!
        silent! autocmd BufWritePre
            \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
            \ setlocal noundofile
    augroup END
endif

" Don't keep viminfo for files in temp directories or shm
if has('viminfo')
    if has('autocmd')
        augroup viminfoskip
            autocmd!
            silent! autocmd BufNewFile,BufReadPre
                \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
                \ setlocal viminfo=
        augroup END
    endif
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
