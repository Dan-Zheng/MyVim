
"                                 vimrc
" =========================================================================
"    Copyright (C) 2015-2017 Dan Zheng <zheng321@purdue.edu>
"
"    Based on the .vimrc of Richard Wei <xinranmsn@gmail.com>
"
"    This program is free software: you can redistribute it and/or modify
"    it under the terms of the GNU General Public License as published by
"    the Free Software Foundation, either version 3 of the License, or
"    (at your option) any later version.
"
"    This program is distributed in the hope that it will be useful,
"    but WITHOUT ANY WARRANTY; without even the implied warranty of
"    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
"    GNU General Public License for more details.
"
"    You should have received a copy of the GNU General Public License
"    along with this program.  If not, see <http://www.gnu.org/licenses/>.
" =========================================================================
"
" Requirements:
" 	OS X / Linux
" 	VIM 7.4+
" 	clang, libclang, python2.6+, python-libs, gcc-c++, cmake
"
" Installation:
"   Run install.sh in MyVim/.
"
" 	YouCompleteMe must be recompiled using the following command:
" 		$ cd ~/.vim/bundle/YouCompleteMe
" 		$ ./install.py --clang-completer
" 	Note that any unresolved dependencies could cause errors. For more
" 	information: http://valloric.github.io/YouCompleteMe/.
"
" Default Font:
" 	Menlo for Powerline
"
" Here We Go:
"
"------------------------ GENERAL -----------------------------
set nocompatible

if has("macunix") || has("mac")
	" patched powerline font
	set guifont=Menlo\ for\ Powerline:h12
elseif has("unix")
	set guifont=Menlo\ 10
else
	set guifont=Menlo:h12
endif

" Enable autoindent
" filetype plugin indent on

" Switch off all auto-indenting
set nocindent
set nosmartindent
set noautoindent
set indentexpr=
filetype indent off
filetype plugin indent off

" Line numbering
set nu
" Autoindent
set ai
" Smart indent
" set smartindent
" Tab size in spaces
set tabstop=4
" Shift operator (>> and <<) size in spaces
set shiftwidth=4
" Convert tabs to spaces
set expandtab
" Show matching brackets
set showmatch
" Show line and column number of cursor
set ruler
" Incremental search
set incsearch
" Hide mode (disabled because of airline)
set noshowmode
" Syntax highlighting
set syntax=automatic
" Enable mouse in all modes
set mouse=a
" Allow backspace over autoindent, end-of-line, start of insert
set backspace=indent,eol,start

syntax on
syntax enable

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

if (filereadable(expand("$HOME/.vim/colors/dan-molokai.vim")))
	colorscheme dan-molokai
elseif (filereadable(expand("$HOME/.vim/colors/molokai.vim")))
	colorscheme molokai
elseif has("macunix") || has("mac")
	colorscheme desertEx
else
	colorscheme desert
endif
"--------------------------------------------------------------

"---------------------- KEY MAPPINGS --------------------------
" Toggle NERDTree
nnoremap <silent> <F5> :NERDTreeToggle<CR>
" Toggle Tagbar
nnoremap <silent> <F4> :TagbarToggle<CR>
" Find current file in NERDTree
nnoremap <leader>n :NERDTreeFind<CR>
" Build Eclim Java project
nnoremap <silent> <leader>jb :ProjectBuild<CR>
" Show Eclim project problems
nnoremap <silent> <leader>jp :ProjectProblems<CR>
" Run Eclim Java project
nnoremap <silent> <leader>jr :Java<CR>
" Import the java class under cursor
nnoremap <silent> <leader>ji :JavaImport<CR>
" Search for the javadocs of the element under cursor
nnoremap <silent> <leader>jd :JavaDocSearch<CR>
" Search context-sensitively for the element under cursor
nnoremap <silent> <leader>js :JavaSearchContext<CR>
" Clear search
nnoremap <silent> cs :noh<CR>
" Window switching
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-l> <C-w>l
" Close buffer
nnoremap <leader>bd :Bclose<CR>
" Select a buffer to close
nnoremap <leader>db :call CloseBuffer()<CR>
" Close all buffers but the current one
nnoremap <leader>bo :BOnly<CR>
" Select a tab to close
nnoremap <leader>dt :call CloseTab()<CR>
" Close current tab
nnoremap <leader>ct :tabc<CR>
" Jump to buffer
nnoremap gb :ls<CR>:b<SPACE>
" Reload
nnoremap <silent> <F3> :so ~/.vimrc<CR> :AirlineRefresh<CR>
" Insert by deleting current word
nnoremap <silent> cx viwc
" Delete current word
nnoremap <silent> dx viwd
" Yank current word
nnoremap <silent> yx viwy
" Insert by deleting current contents in brackets
nnoremap <silent> cz vibc
" Delete current contents in brackets
nnoremap <silent> dz vibd
" Yank current contents in brackets
nnoremap <silent> yz viby
" Insert by deleting current contents in {}
nnoremap <silent> c; viBdO
" Delete current contents in {}
nnoremap <silent> d; viBd
" Yank current contents in {}
nnoremap <silent> y; viBy
" Delete {} (eg. remove {} from a single statement for loop)
nnoremap <silent> dr [{xx]}dd
" Replace the word under cursor
nnoremap <leader>r :%s/\<<C-r><C-w>\>/
" Search files for the word under cursor
nnoremap <leader>s :lvim /\<<C-r><C-w>\>/gj
" Open list window
nnoremap <leader>l :lw<CR>
" cd to current file path
nnoremap <silent> <leader>cd :cd %:p:h<CR>
" Save and make
nnoremap <silent> <leader>m :w<CR>:mak<CR>
" Remove trailing whitespaces
nnoremap <silent> <F6> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
" Paste from system clipboard without formatting (Mac)
nnoremap <leader>p :r !pbpaste<CR>
" Mark window for swapping
nnoremap <silent> <leader>mw :call MarkWindowSwap()<CR>
" Swap current window with marked window
nnoremap <silent> <leader>pw :call DoWindowSwap()<CR>
" Open Startify
nnoremap <silent> <F2> :Startify<CR>
"---------------------------------------------------------------

"------------------------- FUNCTIONS ---------------------------
" Mark window for swapping
function! MarkWindowSwap()
    let g:markedWinNum = winnr()
endfunction

" Swap current window with marked window
function! DoWindowSwap()
    "Mark destination
    let curNum = winnr()
    let curBuf = bufnr( "%" )
    exe g:markedWinNum . "wincmd w"
    "Switch to source and shuffle dest->source
    let markedBuf = bufnr( "%" )
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' curBuf
    "Switch to dest and shuffle source->dest
    exe curNum . "wincmd w"
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' markedBuf
endfunction

" Select a buffer to delete
function! CloseBuffer()
	ls
	let bufNum = input("Close: ")
	if !empty(bufNum)
		exe 'Bclose' bufNum
	endif
endfunction

" Select a tab to delete
function! CloseTab()
	tabs
	let tabNum = input("Close: ")
	if !empty(tabNum)
		exe 'tabc' tabNum
	endif
endfunction

"----------------------------------------------------------------

"--------------------------- VUNDLE -----------------------------
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

" TOOLS
Plugin 'tpope/vim-fugitive'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'Raimondi/delimitMate'
" Faster HTML
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
" Plugin 'Valloric/YouCompleteMe'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'scrooloose/nerdcommenter'
Plugin 'majutsushi/tagbar'
Plugin 'xolox/vim-session'
Plugin 'xolox/vim-misc'
Plugin 'kovisoft/slimv'
Plugin 'danro/rename.vim'
Plugin 'eparreno/vim-l9'
" Fast file navigation
Plugin 'wincent/command-t'
" Enhanced terminal integration, cursor shapes
Plugin 'wincent/terminus'
Plugin 'mhinz/vim-startify'

" LANGUAGES
" For Swift support, follow steps here:
" https://gist.github.com/jlehikoinen/0d78af6246c1183d96ad
" Then, change path to your own swift-vim directory.
if (filereadable(expand('~/swift-vim')))
    Plugin 'file://~/swift-vim'
endif
Plugin 'digitaltoad/vim-pug'
Plugin 'xuhdev/vim-latex-live-preview'
" Plugin 'lervag/vimtex'

" Vim Snippets
" Track the engine.
Plugin 'SirVer/ultisnips'
" Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'
" Snippets directories
let g:UltiSnipsSnippetDirectories=["UltiSnips", "snips"]
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

call vundle#end()

" autocmd vimenter * NERDTree

fixdel
"----------------------------------------------------------------

set hlsearch

augroup filetypedetect
	au! BufNewFile,BufRead *.plist setf plist
	au BufNewFile,BufRead *.f set filetype=scheme
	au BufNewFile,BufRead *.xtx set filetype=tex
	au BufNewFile,BufRead *.sbt set filetype=scala
augroup END

"----------------------- NERDCommenter --------------------------
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
"----------------------------------------------------------------

"------------------------ delimitMate ---------------------------
let delimitMate_expand_cr = 1
"----------------------------------------------------------------

"----------------------- YouCompleteMe --------------------------
" let g:ycm_auto_trigger = 1
let g:EclimCompletionMethod = 'omnifunc'
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
"----------------------------------------------------------------

"------------------------- Vim-Airline --------------------------
let g:airline#extensions#tabline#enabled = 1
if has("macunix") || has("mac")
	let g:airline_powerline_fonts = 1
endif
set laststatus=2 " show airline at all time
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
let g:airline_theme = 'bubblegum'
"----------------------------------------------------------------

"-------------------------- Session -----------------------------
let g:session_autosave = 'no'
let g:session_autoload = 'no'
"----------------------------------------------------------------

"-------------------------- Startify ----------------------------
let g:startify_custom_header = [
			\'      ____                 _____   __                    ',
			\'     / __ \____ _____     /__  /  / /_  ___  ____  ____ _',
			\'    / / / / __ `/ __ \      / /  / __ \/ _ \/ __ \/ __ `/',
			\'   / /_/ / /_/ / / / /     / /__/ / / /  __/ / / / /_/ / ',
			\'  /_____/\__,_/_/ /_/     /____/_/ /_/\___/_/ /_/\__, /  ',
			\'                                                /____/   ',
			\'  Yo. I''m Dan Zheng.',
			\ ]
let g:startify_list_order = [
	\ ['  Recent files:'],
        \ 'files',
        \ ['  Recent files (current directory):'],
        \ 'dir',
        \ ['  Bookmarks:'],
        \ 'bookmarks',
        \ ]
let g:startify_bookmarks = [ '~/.vimrc', '~/.zshrc', '/usr/local/etc/nginx/nginx.conf' ]
let g:startify_files_number = 8
let g:startify_session_dir = '~/.vim/session'
let g:startify_skiplist = [
			\ 'COMMIT_EDITMSG',
			\ $VIMRUNTIME .'/doc',
			\ 'bundle/.*/doc',
			\ '\.DS_Store'
			\ ]
let g:startify_enable_special         = 0
let g:startify_relative_path          = 1
let g:startify_change_to_dir          = 1
let g:startify_session_autoload       = 1
let g:startify_session_persistence    = 1
let g:startify_session_delete_buffers = 1
"---------------------- LaTeX Live Preview ----------------------
let g:livepreview_previewer = 'open -a Skim'
" let g:vimtex_view_method = 'skim'
"----------------------------------------------------------------
