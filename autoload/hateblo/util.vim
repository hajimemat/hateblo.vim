let s:save_cpo=&cpo
set cpo&vim

function! hateblo#util#stripWhitespace(str)
  let l:str = substitute(a:str, '^\s\+', '', '')
  return substitute(l:str,'\s\+$', '', '')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
