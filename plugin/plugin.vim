let s:save_cpo=&cpo
set cpo&vim
" hoge

nmap <leader><leader> :source %<CR>:Unite hajimemat-list<CR>



let &cpo = s:save_cpo
unlet s:save_cpo
