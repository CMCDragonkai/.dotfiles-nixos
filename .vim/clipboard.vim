" JUST FOR CYGWIN
" We want to make use of the Windows Clipboard when running in Cygwin
" That means Yank, uses Putclip
" Paste uses Getclip
" Delete (which is actually cut) uses Cutclip
" Perhaps we need to make use of some other things for actual deletion, that is backspace works to delete things and not put it into a register.

" We need to make sure that Copy, Cut, Paste all use the Window Clipboard
" Next we need to remap a new key that deletes things (`d`) but doesn't put in any clipboard, except the blackhole register like _d.

function! Putclip(type, ...) range
  let sel_save = &selection
  let &selection = "inclusive"
  let reg_save = @@
  if a:type == 'n'
    silent exe a:firstline . "," . a:lastline . "y"
  elseif a:type == 'c'
    silent exe a:1 . "," . a:2 . "y"
  else
    silent exe "normal! `<" . a:type . "`>y"
  endif
  "As of Cygwin 1.7.13, the /dev/clipboard device was added to provide
  "access to the native Windows clipboard. It provides the added benefit
  "of supporting utf-8 characters which putclip currently does not. Based
  "on a tip from John Beckett, use the following:
  call writefile(split(@@,"\n"), '/dev/clipboard')
  let &selection = sel_save
  let @@ = reg_save
endfunction

function! Cutclip(type, ...) range
  let sel_save = &selection
  let &selection = "inclusive"
  let reg_save = @@
  if a:type == 'n'
    silent exe a:firstline . "," . a:lastline . "d"
  elseif a:type == 'c'
    silent exe a:1 . "," . a:2 . "d"
  else
    silent exe "normal! `<" . a:type . "`>d"
  endif
  " call system('putclip', @@)
  call writefile(split(@@,"\n"), '/dev/clipboard')
  let &selection = sel_save
  let @@ = reg_save
endfunction

function! Getclip()
  let reg_save = @@
  "let @@ = system('getclip')
  "Much like Putclip(), using the /dev/clipboard device to access to the
  "native Windows clipboard for Cygwin 1.7.13 and above. It provides the
  "added benefit of supporting utf-8 characters which getclip currently does
  "not. Based again on a tip from John Beckett, use the following:
  let @@ = join(readfile('/dev/clipboard'), "\n")
  setlocal paste
  exe 'normal p'
  setlocal nopaste
  let @@ = reg_save
endfunction

" Visual Mode Copy 
vnoremap <silent> <leader>y :call Putclip(visualmode(), 1)<CR>

" Normal Mode Copy
nnoremap <silent> <leader>y :call Putclip('n', 1)<CR>

" Normal Mode Paste
nnoremap <silent> <leader>p :call Getclip()<CR>

" Actually perhaps, just try this: https://github.com/kana/vim-fakeclip