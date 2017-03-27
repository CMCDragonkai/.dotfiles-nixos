" Want vim not vi
set nocompatible

" Setup pathogen as our package manager
execute pathogen#infect()

" Generate help tags from pathogen packages
Helptags

" Automatic global session persistence, but only for when there are no parameters to the vim command
" The order of autocmds matters, we need load a new session, then run subsequent autocmds

function! SaveSession()
    execute "mksession! /tmp/Session.vim"
    echo "Saved session."
endfunction

function! LoadSession()
    if (filereadable("/tmp/Session.vim"))
        execute "source /tmp/Session.vim"
        echo "Loaded session."
    else
        echo "No session available."
    endif
endfunction

autocmd VimEnter * if argc() == 0 | call LoadSession() | endif
autocmd VimLeavePre * if argc() == 0 | call SaveSession() | endif

" Consider the background as dark
set background=dark

" Choose the colour scheme
colorscheme solarized

" Indent guides
let g:indent_guides_auto_colors = 0
let g:indent_guides_guide_size = 1
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#262626 ctermbg=236
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#262626 ctermbg=236
autocmd VimEnter * :IndentGuidesEnable

" Enable syntax highlighting
syntax on

" Vim takes control of the mouse, but holding shift will switch back to default mouse handling
set mouse=a

" Show number line
set number

" Relative number lines
set relativenumber

" Indent breaks for indented wrapped lines
set breakindent

" Visualisation for wrapped lines
set showbreak=➥\ 

" Always show 1 line above and below the cursor
set scrolloff=1

" Change window title to the file being edited
set title

" Allow the opening of new buffers without closing existing buffers, they become hidden
set hidden

" Change cursor shape when in command or insert mode, also works in TMUX
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
else
    let &t_SI = "\e[5 q"
    let &t_EI = "\e[2 q"
endif

" Show literal tabs as 4 spaces width
set tabstop=4

" 4 columns are used when tab is hit in insert mode
set softtabstop=4

" Tabs are inserted as 4 spaces
set expandtab

" When indenting with '>', use 4 spaces width
set shiftwidth=4

" Show last keystroke commands on the bottom right
set showcmd

" Keep the indentation when entering a new line
set autoindent

" Use custom configuration for different languages
filetype plugin indent on

" Show current line
set cursorline
" Cursor line highlight should be darker than the background
hi CursorLine cterm=NONE ctermbg=black guibg=black
hi CursorLineNR cterm=bold

" Show current column (disabled)
" set cursorcolumn
" Cursor column highlight should be darker than the background
" hi CursorColumn ctermbg=black guibg=black

" Show matching parantheses or brackets
set showmatch
hi MatchParen cterm=bold,underline ctermbg=none

" Visual autocomplete for command menu
set wildmenu

" Lazy redrawing of the screen, resulting in faster macros
set lazyredraw

" Incremental search
set incsearch

" Highlight search matches
set hlsearch

set statusline=%F%m%r%<\ %=%l,%v\ [%L]\ %p%%
hi statusline ctermbg=white ctermfg=black
set laststatus=2

" Enable swapfiles to guard against crashes (appears as `.file.swp`)
set swapfile
" Enable a persistent undo (appears as `.file.un~`)
set undofile
" Do not create persistent backups (as we already have persistent undo) (would appear as `file~`)
set nobackup
" Do create a backup just before overwriting the file (will appear as `file~`)
set writebackup

" Code folding based on indentation
set foldmethod=indent
" Don't fold anything by default
set nofoldenable
" Starting the folding level at 1 + the highest fold level in the file
autocmd BufWinEnter * normal zR

" Use Shift + Tab to insert a literal tab
inoremap <S-Tab> <C-V><Tab>

" Use the comma as the leader key
let mapleader=","

" Visually show tabs and newline-terminated spaces (this is useful for looking up erroneous whitespace)
set listchars=tab:•·,trail:·,extends:>,precedes:<
set list

" Check the file for changes to reload if after user input then idle cursor for X seconds (where X is by default 4)
" If we have not made any changes, it reloads automatically, if we have made changes, there will be a prompt asking us what to do
set autoread
au CursorHold,CursorHoldI * if getcmdwintype() == '' | checktime | endif

" Set backspace to be able to backspace pass insert start, indentation and end of line in insert mode
set backspace=indent,eol,start

" Allow left right arrow and space key to move past newlines in all modes
" It doesn't work for backspace, because we mapped backspace to X,x, and these cannot move past newlines
set whichwrap=b,s,<,>,[,]

" In normal mode, we make Backspace and Del keys delete without cutting to a register
" This aligns Backspace and Del key behaviour to most modeless editors
" Basically this will mean it won't clobber our copying registers.
" The _ is the blackhole register
" The x, X, d, D still cut normally, they don't just delete
" If you want a non-cutting d/D, just use visual mode + X and x
nnoremap <BS> "_X
nnoremap <Del> "_x

" In visual mode, X ends up deleting the entire line, so to align behaviour, we use x instead.
vnoremap <BS> "_x
vnoremap <Del> "_x

" Move vertically by line visually, this is useful for wrapped lines (don't skip the wrapped lines!)
" This behaviour aligns it with standard text editors
nnoremap k gk
nnoremap <Up> gk
nnoremap j gj
nnoremap <Down> gj

" Reset the search highlight
nnoremap <leader><space> :nohlsearch<CR>

" Map to gundo
nnoremap <leader>u :GundoToggle<CR>