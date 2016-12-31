let s:save_cpo=&cpo
set cpo&vim
" hoge

nmap <leader><leader> :source %<CR>

let g:hateblo_draft_marker = "D:"
augroup hateble_env
  autocmd!
  autocmd BufWriteCmd hateblo:* call hateblo#editor#save()
  autocmd FileType *.hateblo call s:hateblo_env()
augroup END

function! s:hateblo_env()
  cmap w :wwwwww
endfunction


" command! -nargs=0 Test call hateblo#editor#edit(
"   \ hateblo#entry#getList()[0]['entry_url'])
" command! -nargs=0 TestUp call plugin#editEntry(b:entry_url)
" command! -nargs=0 TestSave call plugin#saveEntry()
" command! -nargs=0 TestCreate call plugin#createEntry()
" command! -nargs=0 TestS echo plugin#getCandidates()[0]
" command! -nargs=0 TestParse call plugin#parseFirstLine(getline(1))
" command! -nargs=0 TestParse call plugin#parseFirstLine(getline(1))


let &cpo = s:save_cpo
unlet s:save_cpo
