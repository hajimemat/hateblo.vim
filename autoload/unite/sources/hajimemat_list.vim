let s:save_cpo=&cpo
set cpo&vim

let s:unite_hajimemat_list_source = {
      \ 'name': 'hajimemat-list',
      \ 'description': 'Entry list of hateblo',
      \ 'action_table': {
      \  'on_choose': {
      \   }
      \ },
      \ 'default_action': 'on_choose'
      \ }

function! s:unite_hajimemat_list_source.action_table.on_choose.func(candidate)
  echo a:candidate.action__action
endfunction

function! s:unite_hajimemat_list_source.gather_candidates(args, context)
  call s:getEntriesList()
  let l:entries = b:entries
  let l:list = []
  for l:entry in l:entries
    call add(l:list, {
      \ 'word': l:entry['title'],
      \ 'source': 'hajimemat-list'
      \})
  endfor
  return l:list
endfunction


function! s:getEntriesList(...)
  let l:api_url = 'https://blog.hatena.ne.jp/kurari0118/hajime-mat.hateblo.jp/atom/entry'
  let l:feed = webapi#atom#getFeed(l:api_url, g:hateblo_vim['user'],g:hateblo_vim['api_key'])
  let b:entries = l:feed['entry']
  echo b:entries
endfunction

function! unite#sources#hajimemat_list#define()
  return s:unite_hajimemat_list_source
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
