" Author: Frederico Benevides

if exists("g:loaded_line_mover") || &cp
  finish
endif
let g:loaded_line_mover = 1

if !exists('g:line_mover_key_up')
  let g:line_mover_key_up = '<A-k>'
endif

if !exists('g:line_mover_key_down')
  let g:line_mover_key_down = '<A-j>'
endif

let s:lines_to_move_up = 2
let s:lines_to_move_down = 1

" Move Functions {{{1
function! s:MoveLineUp()
  let before_line = line(".") - s:lines_to_move_up

  if s:isFirstLine(before_line)
    return
  endif

  let mCmd = "m -" . s:lines_to_move_up
  call s:MoveLineAndIndent(mCmd)
endfunction

function! s:MoveLineDown()
  let next_line = line(".") + s:lines_to_move_down

  if s:isEndOfLine(next_line)
    return
  endif

  let mCmd = "m +" . s:lines_to_move_down
  call s:MoveLineAndIndent(mCmd)
endfunction

function! s:MoveBlockUp() range
  let before_line = line(".") + s:lines_to_move_up

  if s:isFirstLine(before_line)
    return
  endif

  let mCmd = a:firstline . "," . a:lastline . "m '<-" . s:lines_to_move_up
  call s:MoveLineAndIndent(mCmd)

  normal! gv
endfunction

function! s:MoveBlockDown() range
  let next_line = line(".") + s:lines_to_move_down

  if s:isEndOfLine(next_line)
    return
  endif

  let mCmd = a:firstline . "," . a:lastline . "m '>+" . s:lines_to_move_down
  call s:MoveLineAndIndent(mCmd)

  normal! gv
endfunction

function! s:MoveLineAndIndent(mCmd)
  exe a:mCmd
  call s:indentLine()
endfunction
" }}}1

" Utilities functions {{{1
function! s:indentLine()
  exe "normal! =="
endfunction
" }}}

function! s:isFirstLine(currentLine)
  return a:currentLine < line("0")
endfunction

function! s:isEndOfLine(currentLine)
  return a:currentLine > line("$")
endfunction

nnoremap <silent> <Plug>MoveLineUp :call <SID>MoveLineUp()<cr>
nnoremap <silent> <Plug>MoveLineDown :call <SID>MoveLineDown()<cr>

vnoremap <silent> <Plug>MoveBlockUp :call <SID>MoveBlockUp()<cr>
vnoremap <silent> <Plug>MoveBlockDown :call <SID>MoveBlockDown()<cr>

execute "nmap " g:line_mover_key_up "<Plug>MoveLineUp"
execute "nmap " g:line_mover_key_down "<Plug>MoveLineDown"

execute "vmap " g:line_mover_key_up "<Plug>MoveBlockUp"
execute "vmap " g:line_mover_key_down "<Plug>MoveBlockDown"
