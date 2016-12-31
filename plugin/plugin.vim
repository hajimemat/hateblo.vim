" hoge
set nonumber

nmap <leader><leader> :source %<CR>
let title = s:get_title()

function! s:get_title()
  echo getline(1)
  return "a"
endfunction

echo title
