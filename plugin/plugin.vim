let s:save_cpo=&cpo
set cpo&vim

if exists("g:loaded_hateblo")
  finish
endif

nmap <leader><leader> :source %<CR>

let g:hateblo_draft_marker = "D:"
augroup hateble_env
  autocmd!
  autocmd BufWriteCmd hateblo:* call hateblo#editor#save()
  autocmd FileType *.hateblo call s:hateblo_env()
augroup END

function! s:hateblo_env()
  cmap <buffer> w call hateblo#editor#save()<CR>
endfunction


"command! -nargs=0 HatebloList Unite 
"   \ hateblo#entry#getList()[0]['entry_url'])
" command! -nargs=0 TestUp call plugin#editEntry(b:entry_url)
" command! -nargs=0 TestSave call plugin#saveEntry()
" command! -nargs=0 TestCreate call plugin#createEntry()
" command! -nargs=0 TestS echo plugin#getCandidates()[0]
" command! -nargs=0 TestParse call plugin#parseFirstLine(getline(1))
" command! -nargs=0 TestParse call plugin#parseFirstLine(getline(1))
let g:loaded_hateblo = 1

let &cpo = s:save_cpo
unlet s:save_cpo
