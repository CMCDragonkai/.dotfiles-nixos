" Vim takes control of the mouse, but holding shift will switch back to default mouse handling
set mouse=a

" Show number line
set number

" Show existing tab with 4 spaces width
set tabstop=4

" When indenting with '>', use 4 spaces width
set shiftwidth=4

" On pressing tab, insert 4 spaces
set expandtab

" Use Shift + Tab to insert a literal tab
inoremap <S-Tab> <C-V><Tab>

" Visually show tabs and newline-terminated spaces (this is useful for looking up erroneous whitespace)
set listchars=tab:•·,trail:·,extends:>,precedes:<
set list

" Check the file for changes to reload if after user input then idle cursor for X seconds (where X is by default 4)
" If we have not made any changes, it reloads automatically, if we have made changes, there will be a prompt asking us what to do
set autoread
au CursorHold,CursorHoldI * if getcmdwintype() == '' | checktime | endif

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