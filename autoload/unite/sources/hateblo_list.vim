let s:save_cpo=&cpo
set cpo&vim
" Unite用

let s:source = {
      \ 'name': 'hateblo-list',
      \ 'description': 'Entry list of hateblo',
      \ 'action_table': {
      \  'on_choose': {
      \   }
      \ },
      \ 'default_action': 'on_choose'
      \ }

function! s:source.gather_candidates(args,context)
  return hateblo#entry#getList()
endfunction

function! s:unite_action_on_choose(candidate)
  echo a:candidate
  if a:candidate.action__action == 'edit_entry'
    call hateblo#editor#edit(a:candidate['action__entry_url'])
  else
    echo 'not impl'
  endif
endfunction

function! s:source.action_table.on_choose.func(candidate)
    call s:unite_action_on_choose(a:candidate)
endfunction

function! unite#sources#hateblo_list#define()
  return s:source
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
