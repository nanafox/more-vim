" Define a command named Trail that removes trailing whitespace
command! -nargs=0 Trail :call TrailRemoveWhitespace()

" Function to remove trailing whitespace
function! TrailRemoveWhitespace()
  " Save the current cursor position
  let save_cursor = getpos(".")
  
  " Enable hidden characters (including trailing whitespace)
  set list listchars=trail:·
  
  " Replace trailing whitespace with nothing
  %s/\s\+$//e
  
  " Restore the cursor position
  call setpos(".", save_cursor)
  
  " Disable the display of hidden characters
  set nolist
endfunction
