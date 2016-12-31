
function! hateblo#util#stripWhitespace(str)
  let l:str = substitute(a:str, '^\s\+', '', '')
  return substitute(l:str,'\s\+$', '', '')
endfunction
