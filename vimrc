""""""""""""""""""""""""""""""""""
"                                "
"            General             "
"                                "
"""""""""""""""""""""""""""""""""" 
" All system-wide defaults are set in $VIMRUNTIME/debian.vim (usually just
" /usr/share/vim/vimcurrent/debian.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vim/vimrc), since debian.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing debian.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
"runtime! debian.vim
	" delete character under cursor
"

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

"
" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the
" following enables syntax highlighting by default.

""""""""""""""""""""""""""""""""""
"                                "
"            UI Stuff            "
"                                "
"""""""""""""""""""""""""""""""""" 

" General options
syntax on
set term=xterm
set nopaste
set showmatch  " Show matching brackets.
set incsearch  " Incremental search, ie go to search term as you type it.
set hlsearch   " Highlight search results.
" set textwidth=80

" Set tabs and shiftwidths
set rs          " What does rs do?
set autoindent
set expandtab   " Uses spaces instead of tabs.
set smarttab    " Delete 'space' tabs with one backspace
set shiftwidth=4  " # of spaces used for auto indent
set tabstop=4     " 1 tab = 4 spaces

" No annoying sound/flash on errors
set noerrorbells
set novisualbell
" set t_vb=
" set tm=500

" Colors
set background=dark
colorscheme elflord
" colorscheme delek
" colorscheme elflord
" colorscheme zellner
" colorscheme slate
" colorscheme torte

" Status Line
set statusline=%F%m%r%h%w\ %{HasPaste()}[%04l\/%L\|%03v]\ ASC=\%03.3b\ HEX=\%02.2B
set laststatus=2

"Add a splash messages to output on loading vim
"echo '>^.^<'


""""""""""""""""""""""""""""""""""
"                                "
"          Keymappings           "
"                                "
"""""""""""""""""""""""""""""""""" 
nnoremap ' `
cnoremap w!! w !sudo tee >/dev/null % " What does this do?

" For Emacs-style editing on the command-line: >
	" start of line
	cnoremap <C-A>		<Home>
	" back one character
	cnoremap <C-B>		<Left>
	" end of line
	cnoremap <C-E>		<End>
	" forward one character
	cnoremap <C-F>		<Right>
	" recall newer command-line
	cnoremap <C-N>		<Down>
	" recall previous (older) command-line
	cnoremap <C-P>		<Up>
	" back one word
	cnoremap <Esc><C-B>	<S-Left>
	" forward one word
	cnoremap <Esc><C-F>	<S-Right>
" NOTE: This requires that the '<' flag is excluded from 'cpoptions'. |<>|

" Set Mapleader
let mapleader = ";"

" Delete a line
nnoremap <space> dd
vnoremap <space> d

" Create new line with enter key, stay in normal mode.
nnoremap <cr> mzI<cr><esc>`zj

" Indent in normal mode
nnoremap <leader><tab> V>
nnoremap <leader><BS> V<

" Move lines up and down
nnoremap - ddp
nnoremap _ ddkP


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

" Add quotes, brackets around current word.
nnoremap <leader>[ mvwbi[<Esc>ea]<Esc>`vl
nnoremap <leader>( mvwbi(<Esc>ea)<Esc>`vl
nnoremap <leader>' mvwbi'<Esc>ea'<Esc>`vl
nnoremap <leader>" mvwbi"<Esc>ea"<Esc>`vl

" Uppercase, lowercase current word.
nnoremap <leader>U mvbveUh`v
nnoremap <leader>u mvbveuh`v

" Move to first non-empty character
nnoremap <leader>4 g_
nnoremap <leader>0 _g

" TEST ON ME 'blah' blah '('blah') "blachblah" blahb '

" window manipulation
nnoremap <leader>i 
nnoremap <leader>a 
nnoremap <leader>f _\|

" 'No-buffer' yank
noremap <leader>y "1y   
noremap <leader>Y "1Y
noremap <leader>p "1p
noremap <leader>P "1p

" Move letters around.
nnoremap <leader>l "zdlp
nnoremap <leader>h "zdhph
nnoremap <leader>k "zdlkP
nnoremap <leader>j "zdljP

"Search for letter under cursor
nnoremap <leader>z "zyl/<C-R>z<cr>

"Get rid of highlighting
nnoremap <leader>nh :nohl<cr>

"Set syntax highlighting
nnoremap <leader>php :set syntax=php<cr>

" Comment the current line.
" `` == return to previous cursor position.
noremap <leader>cc :s/^/\/\//<cr>:let @/=""<cr>``<right><right>
noremap <leader>ch :s/^/#/<cr>:let @/=""<cr>``<right>
noremap <leader>cv :s/^/"/<cr>:let @/=""<cr>``<right>

" Remove comment from the current line.
noremap <leader>crc :s/^\/\//<cr>``:let @/=""<cr>
noremap <leader>crh: s/^#//<cr>``:let @/=""<cr>
noremap <leader>crv :s/^"//<cr>``:let @/=""<cr>

" Visual mode shortcuts
" Comment a selected block of text
" Also, try ctrl-v j,j,j, I <text to insert> <esc>
"'<,'> is the selection range, this is added automatically to the beginning of the ex command.
" vnoremap <leader>cb :s/^//*\/\//<cr>:let @/=""<cr>
" vnoremap <leader>cc <cr>:s/^/\/\/ha/<cr>:let @/=""<cr>
" vnoremap <leader>ch :s/^/#/<cr>:let @/=""<cr>
" vnoremap <leader>cv :s/^/"/<cr>:let @/=""<cr>

" Remove comments.
" "'<,'> is the selection range, this is added automatically to the beginning of the ex command.
" vnoremap <leader>crb :s/^/\/\//<cr>:let @/=""<cr>
" vnoremap <leader>crc :s/^\/\//<cr>:let @/=""<cr>
" vnoremap <leader>crh :s/^#//<cr>:let @/=""<cr>
" vnoremap <leader>crv :s/^"//<cr>:let @/=""<cr>

" Search for text in visual mode
" vnoremap / y/<C-R>"

" Select java-style comment blocks.
vnoremap i* ?/\*<CR>vv/\*\/<CR>ll
vnoremap a* <esc>0v/\/\*<CR>vv/\*\/<CR>ll

" Edit in hex mode
nnoremap <leader><leader>h :%!xxd<cr>

" Remove hex mode
nnoremap <leader><leader>nh :%!xxd -r<cr>

" Toggle spellcheck
noremap <leader><leader>s :setlocal spell!<cr>

" Toggle paste
noremap <leader><leader>p :setlocal paste!<cr>

" Move to the top of the file
nnoremap <leader><leader><space> gg

" Move selections around.
" TODO
" vnoremap <leader>j  "zdjPV
" vnoremap <leader>k  "zdkPV

" Fun with buffers
nnoremap <F5> :buffers<CR>:buffer 

" Insert blocks of static text:
"function! Insert(type)
"    echom a:type
" TODO figure out how to use a filename as an arg
"    r ~/.vim/snippets/a:type
"    r ~/.vim/snippets/twitter-modal
"endfunction

" nnoremap <leader>mchp :r ~/.vim/snippets/class-header.php<cr>
" nnoremap <leader>mmhp :r ~/.vim/snippets/function-header.php<cr>
" nnoremap <leader>mfhp :r ~/.vim/snippets/function-header.php<cr>
" nnoremap <leader>mhh  :r ~/.vim/snippets/html.html<cr>

" Language specific mappings "
" let maplocalleader="]"
" map <localleader>

""""""""""""""""""""""""""""""""""
"                                "
"          Saved macros          "
"                                "
"""""""""""""""""""""""""""""""""" 
" 
" To save a macro you can do:
" 
"     From normal mode: q<bufferletter>
"     enter whatever commands
"     From normal mode: q
"     open .vimrc
"     q"<bufferletter>p to insert the macro into your let @q = '...' line
" 
" Be careful of quotes, though. They would have to be escaped properly.

" Takes line of sql results with delimiters |,  turns into csv
let @j=":'a,'bs/^\\s*|\\?\\s*\\(\\w\\+\\)\\s*|\\?.*$/'\\1',/g"
" Takes line of sql results with tab delimiters |, turns into csv 
let @c=":%s/\\t/\",\"/g"
let @s=":%s/^\\(.*\\)$/\"\\1\"/g"

""""""""""""""""""""""""""""""""""
"                                "
"         Vim functions          "
"                                "
"""""""""""""""""""""""""""""""""" 
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return ' [P] '
    endif
    return ''
endfunction

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
"set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
"set autowrite		" Automatically save before commands like :next and :make
"set hidden         " Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)


"
" associate filetypes with syntax
autocmd BufRead,BufNewFile *.less set syntax=css
autocmd BufRead,BufNewFile *.json set syntax=javascript
autocmd BufRead,BufNewFile *.html set syntax=php

" Pathogen
execute pathogen#infect()

" Syntastic -- Linter and Syntax Checker
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Config
let g:syntastic_check_on_open = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_wq = 1

" Syntastic Checkers
let g:syntastic_php_checkers = ["php", "phpcs", "phpmd"]
let g:syntastic_javascript_checkers = ["jshint"]
let g:syntastic_json_checkers = ["jsonlint"]
