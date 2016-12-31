" Unite用

let s:source = {
      \ 'name': 'hateblo-list',
      \ 'description': 'Entry list of hateblo',
      \ 'action_table': {
      \  'on_choose': {
      \   },
      \  'publish': {
      \   'description': '公開する'
      \  }
      \ },
      \ 'default_action': 'on_choose'
      \ }

function! s:source.gather_candidates(args,context)
  return hateblo#entry#getList()
endfunction

function! s:source.action_table.on_choose.func(candidate)
  echo a.candidate
endfunction

function! unite#sources#hateblo_list#define()
  return s:source
endfunction
