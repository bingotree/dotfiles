" All system-wide defaults are set in $VIMRUNTIME/debian.vim (usually just
" /usr/share/vim/vimcurrent/debian.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vim/vimrc), since debian.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing debian.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

"
"
" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the
" following enables syntax highlighting by default.
if has("syntax")
  syntax on
endif

" Set tabs and shiftwidths
set rs term=builtin_ansi ai et smarttab ts=4 shiftwidth=4

" Set keymappings here:
noremap d; d/;<CR>
noremap tw ve~h 
noremap [] i[<Esc>ea]
cnoremap w!! w !sudo tee >/dev/null %

" Make space more useful
noremap <space> ve
noremap - ddp
noremap _ ddkP

" Create closing brackets, parens, goto edit the space between.
inoremap [[ []<esc>i
inoremap (( ()<esc>i
inoremap [" ["]<esc><left>i"
inoremap [' [']<esc><left>i'
inoremap (" (")<esc><left>i"
inoremap (' (')<esc><left>i'
inoremap {{ <cr>{<cr>}<esc>O<tab>

" More escape options
inoremap asdf <Esc>

let mapleader = ";"
noremap <leader><leader> <Esc>

" Edit and source vimrc file quickly
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Save and exit short cuts.
nnoremap <leader>w :w<cr>
nnoremap <leader>x :x<cr>
nnoremap <leader>q :q<cr>

" Buffer short cuts
nnoremap <leader>bv :bp<cr>
nnoremap <leader>bn :bn<cr>
nnoremap <leader>bb :bn<cr>
nnoremap <leader>bl :ls<cr>
nnoremap <leader>ba :ball<cr>

" Move letters around.
nnoremap <leader>l "zdlp
nnoremap <leader>h "zdhph
nnoremap <leader>t "zdlph
nnoremap <leader>k "zdlkP
nnoremap <leader>j "zdljP

" Comment the current line.
" `` == return to previous cursor position.
noremap <leader>cc :s/^/\/\//<cr>``<right><right>
noremap <leader>ch :s/^/#/<cr>``<right>
noremap <leader>cv :s/^/"/<cr>``<right>

" Remove comment from the current line.
noremap <leader>crc :s/^\/\//<cr>``
noremap <leader>crh: s/^#//<cr>``
noremap <leader>crv :s/^"//<cr>``

" Visual mode shortcuts
" Comment a selected block of text
" Also, try ctrl-v j,j,j, I <text to insert> <esc>
"'<,'> is the selection range, this is added automatically to the beginning of the ex command.
vnoremap <leader>cb :s/^//*\/\//<cr>
vnoremap <leader>cc :s/^/\/\//<cr>
vnoremap <leader>ch :s/^/#/<cr>
vnoremap <leader>cv :s/^/"/<cr>

" Remove comments.
"'<,'> is the selection range, this is added automatically to the beginning of the ex command.
vnoremap <leader>crb :s/^/\/\//<cr>
vnoremap <leader>crc :s/^\/\//<cr>
vnoremap <leader>crh :s/^#//<cr>
vnoremap <leader>crv :s/^"//<cr>

" Move selections around.
" TODO

" Insert blocks of static text:
"function! Insert(type)
"    echom a:type
" TODO figure out how to use a filename as an arg
"    r ~/.vim/snippets/a:type
"    r ~/.vim/snippets/twitter-modal
"endfunction
"nnoremap <leader>mm :call Insert('twitter-modal')<cr>

nnoremap <leader>mchp :r ~/.vim/snippets/class-header.php<cr>
nnoremap <leader>mmhp :r ~/.vim/snippets/function-header.php<cr>
nnoremap <leader>mfhp :r ~/.vim/snippets/function-header.php<cr>
nnoremap <leader>mhh :r ~/.vim/snippets/html.html<cr>
" let maplocalleader="]"
" map <localleader>

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
"set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
"if has("autocmd")
"  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
"endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
"if has("autocmd")
"  filetype plugin indent on
"endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
"set showcmd		" Show (partial) command in status line.
"set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
"set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
"set hidden             " Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

"Add a splash messages to output on loading vim
"echo '>^.^<'
