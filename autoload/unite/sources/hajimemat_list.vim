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
  echo a:candidate
  call s:detailEntry(a:candidate:entry_url)
endfunction

function! s:unite_hajimemat_list_source.gather_candidates(args, context)
  call s:getEntriesList()
  let l:entries = b:entries
  let l:list = []
  for l:entry in l:entries
    call add(l:list, {
      \ 'word': l:entry['title'],
      \ 'source': 'hajimemat-list',
      \ 'kind': 'file',
      \ 'entry_url': l:entry['link'][0]['href'],
      \ 'draft': l:entry['app:control']['app:draft']
      \})
  endfor
  return l:list
endfunction

function! s:detailEntry(entry_url)
  let l:entry = webapi#atom#getEntry(a:entry_url, g:hateblo_vim['user'],g:hateblo_vim['api_key'])
  echo l:entry
  call append(0, split(l:entry['content'], '\n'))
endfunction


function! s:getEntriesList(...)
  let l:api_url = 'https://blog.hatena.ne.jp/kurari0118/hajime-mat.hateblo.jp/atom/entry'
  let l:feed = webapi#atom#getFeed(l:api_url, g:hateblo_vim['user'],g:hateblo_vim['api_key'])
  let b:entries = l:feed['entry']
  return b:entries
endfunction

function! unite#sources#hajimemat_list#define()
  return s:unite_hajimemat_list_source
endfunction

"call s:detailEntry('https://blog.hatena.ne.jp/kurari0118/hajime-mat.hateblo.jp/atom/entry/10328749687202342149')

let &cpo = s:save_cpo
unlet s:save_cpo
