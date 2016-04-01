" Tell vim to check 1 line for file-specific settings (see last line)
set modelines=1

" General {{{

" Ignore backwards compatibility to vi
set nocompatible

" Always display current mode
set showmode

" Show line numbers
set number

" Prefer utf-8
set encoding=utf8

" Enable syntax highlighting
syntax on

" Set margin for the zt and zb commands
set scrolloff=3

" Allow mouse clicks to change cursor position
if has('mouse')
    set mouse=a
endif

" No sounds on errors
set noerrorbells

" Display current line and column in the bottom-right corner
set ruler

" Always show vim-airline
set laststatus=2

" Unrestricted use of the backspace key in insert mode
set backspace=indent,eol,start

" Use the filetype plugin
filetype plugin on

" Allow yank and put between vim sessions without specifying
" the clipboard ("*) register
set clipboard+=unnamed

" }}}

" Colors {{{

" Enable 256 color mode
if !has('gui_running')
    set t_Co=256
endif

" Set the default colorscheme
try
    colorscheme hybrid
catch
endtry

" }}}

" Pathogen {{{

" Update runtimepath with plugins from ~/.vim/bundle/
execute pathogen#infect()

" Generate help tags
execute pathogen#helptags()

" }}}

" Leader shortcuts {{{

" Set leader character
let mapleader="\<space>"

" Set the local leader character
let maplocalleader="\<space>"

" Display the syntax group(s) of the current word
nnoremap <leader>sg :call <SID>SynStack()<CR>

" Shortcut for disabling highlighting
nnoremap <silent> <leader><space> :nohl<cr>

" Quickly toggle paste mode
nnoremap <leader>pp :setlocal paste!<cr>

" Tab navigation shortcuts
nnoremap <leader>h gT
nnoremap <leader>l gt

" Quickly save the current buffer
nnoremap <leader>w :w<cr>

" Quickly close the current buffer
nnoremap <leader>q :q<cr>

" }}}

" Searching {{{

" Highlight searches
set hlsearch

" Use incremental search
set incsearch

" Do not jump forward to the next match when searching for the current word
nnoremap * *N

" }}}

" Tabs, spaces and indentation {{{

" Always use spaces instead of tabs
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" Always use autoindenting
set autoindent

" }}}

" Tabs (the buffer ones) {{{

nnoremap <C-t> :tabnew<cr>

" }}}

" Windows {{{

" Shortcuts for vim window navigation
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Open vsplits on the right side
set splitright

" Change two vertically split windows to a horizontal layout
" Mnenomic: Swap Windows to Horizontal
nnoremap <leader>swh <c-w>t <c-w>K

" Change two horizontally split windows to a vertical layout
" Mnenomic: Swap Windows to Vertical
nnoremap <leader>swv <c-w>t <c-w>H

" }}}

" Mappings {{{

" Move vertically while ignoring true lines
nnoremap j gj
nnoremap k gk

" Auto-close curly brackets after pressing [Enter]
inoremap {<CR> {<CR>}<C-o>O

" Shortcut for editing the vimrc file
nnoremap <leader>ev :sp $MYVIMRC<cr>
nnoremap <leader>evv :vsp $MYVIMRC<cr>

" Shortcut to reload the vimrc file
nnoremap <leader>sv :source $MYVIMRC<cr>

" Easily swap the current line up and down
nnoremap J :m .+1<cr>
nnoremap K :m .-2<cr>

" Quicker way to exit insert mode
inoremap jk <esc>

" Open the 'goto file' in a new tab
nnoremap gf <c-w>gf

" Yank from cursor to the end of line instead of the entire line
nnoremap Y y$

" Shortcut for calling '!make'
nnoremap <leader>m :!make<cr>

" }}}

" Folding {{{

" Disable folding by default
set nofoldenable

" Using indentation to determine folding
set foldmethod=indent

" Maximum nesting for folds is 3
set foldnestmax=3

" }}}

" Commands {{{

if has('mac') || has('macunix')
	command! -nargs=? Dict call OpenDictionary(<q-args>)
endif

" }}}

" Autocommands {{{

if has("autocmd")
    augroup clike
        " Use C-style indentation rules for C/C++/CUDA
        autocmd FileType c setlocal cindent
        autocmd FileType cpp setlocal cindent
        autocmd FileType cuda setlocal cindent
    augroup END

    augroup scons
        " Use Python syntax for SCons files
        autocmd BufReadPost SCons* set filetype=python
        autocmd BufRead,BufNewFile *.scons set filetype=python
    augroup END

    augroup python
        " Highlight text if it goes over 80 columns in Python
        autocmd FileType python set colorcolumn=80
        "autocmd FileType python highlight ColorColumn ctermbg=235 guibg=#2c2d27

        " Automatically delete trailing whitespace when saving Python files
        autocmd BufWrite *.py :call DeleteTrailingWhitespace()
    augroup END

    augroup json
        " Using javascript highlighting for json files
        autocmd BufRead,BufNewFile *.json set filetype=javascript
    augroup END

    augroup handlebars
        " Using html highlighting for handlebars files
        autocmd BufRead,BufNewFile *.hbs set filetype=html
    augroup END

    augroup latex
        " Enable spell-checking for Latex files
        autocmd FileType tex,plaintex set spell spelllang=en_gb
    augroup END

    augroup makefile
        " Switch indentation to use tabs instead of spaces for makefiles
        autocmd BufRead,BufNewFile Makefile set noexpandtab
    augroup END

    augroup save_edit_position
      " Remember last editing position (see ':h last-position-jump')
      autocmd BufReadPost *
          \ if line("'\"") > 1 && line("'\"") <= line("$") |
          \   execute "normal! g`\"" |
          \ endif
    augroup END
endif

" }}}

" Shell {{{

" Allow external bash commands inside vim to use aliases etc.
"set shell=bash\ --rcfile\ ~/.bash_profile

" }}}

" Explorer {{{

" Show stats in :Explorer mode
let g:netrw_liststyle=3

" }}}

" Functions {{{

" Show syntax group for current word
function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif

    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction

" Function that deletes trailing whitespace
function! DeleteTrailingWhitespace()
    " Save current search history and position
    let s = @/
    let line = line('.')
    let col = col('.')

    " '%' specifies the entire file, 'e' supresses error messages
    %s/\s\+$//e

    " Restore previous search history and position
    let @/=s
    call cursor(line, col)
endfunction

" Open Dictionary.app on mac systems
function! OpenDictionary(...)
	let word = ''

    if a:1 !=# ''
        let word = a:1
    else
        let word = shellescape(expand('<cword>'))
    endif

    silent execute '!open dict://' . word
	redraw!
endfunction

" }}}

" NERDTree {{{

" Shortcut to toggle NERDTree
noremap <C-n> :NERDTreeToggle<CR>

" }}}

" vim-airline {{{

" Fancy tabs!
let g:airline#extensions#tabline#enabled=1

" Show tab numbers
let g:airline#extensions#tabline#show_tab_nr=1
let g:airline#extensions#tabline#tab_nr_type=1

" Do not show buffers when only a single tab is open
let g:airline#extensions#tabline#show_buffers=0

" Use the sweet powerline fonts
let g:airline_powerline_fonts=1

" Enable the Syntastic plugin for vim-airline
let g:airline#extensions#syntastic#enabled=1

" }}}

" vim-surround {{{

" Quickly surround text with LaTeX (e)nvironments
"
" For example, typing 'ySwe' followed by 'center' when prompted on the text '|hello'
" where '|' is the cursor yields:
"
" \begin{center}
"     hello
" \end{center}
let g:surround_{char2nr('e')}="\\begin{\1environment: \1}\r\\end{\1\1}"

" Quickly surround text with LaTeX markup
"
" For example, typing 'ySwl' followed by 'textbf' when prompted on the text '|vim'
" where '|' is the cursor yields:
"
" \textbf{vim}
let g:surround_{char2nr('l')}="\\\1markup: \1{\r}"

" }}}

" Syntastic {{{

" Use flake8 for Python files
let g:syntastic_python_checkers=['flake8']

" Use clang/clang++ for C/C++
let g:syntastic_c_checkers=['clang']
let g:syntastic_cpp_checkers=['clang++']

" Enable C++11 support in clang++
let g:syntastic_cpp_compiler='clang++'
let g:syntastic_cpp_compiler_options='-std=c++11 -stdlib=libc++'

" Enable C# support using Mono
let g:syntastic_cs_checkers=['mcs']

" Enable Syntastic for plaintex files
let g:tex_flavor='tex'
let g:syntastic_plaintex_checkers=['lacheck']

" Enable Syntastic for Scala
let g:syntastic_scala_checkers=['fsc']

" Check syntax when opening files
let g:syntastic_check_on_open=1

" Set unicode symbols
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_style_warning_symbol='⚡'
let g:syntastic_style_error_symbol='⛔'

" }}}

" UltiSnips {{{

" Set the private UltiSnips directory
let g:UltiSnipsSnippetsDir='~/.vim/bundle/ultisnips/UltiSnips'

" Split the :UltiSnipsEdit window horizontally or vertically depending on context
let g:UltiSnipsEditSplit='context'

" Open the snippets file for the current file type
nnoremap <leader>us :UltiSnipsEdit<cr>

" }}}

" neocomplete {{{

" Enable neocomplete at startup
let g:neocomplete#enable_at_startup=1

" }}}

" vim:foldenable:foldmethod=marker:foldlevel=0
