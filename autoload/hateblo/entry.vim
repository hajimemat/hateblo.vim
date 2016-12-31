" エントリの処理

" エントリ一覧を取得する
function! hateblo#entry#getEntries()
  let l:api_url = hateblo#webapi#getEntryEndPoint()
  echo l:api_url
  let l:feed = webapi#atom#getFeed(l:api_url, g:hateblo['user'],g:hateblo['api_key'])
  let b:entries = l:feed['entry']
  return b:entries
endfunction

function! hateblo#entry#getList()
  let l:entries = hateblo#entry#getEntries()
  let l:list = []
  for l:entry in l:entries
    if l:entry['app:control']['app:draft'] == 'yes'
      let l:word = '[draft] '.l:entry['title']
    else
      let l:word = l:entry['title']
    endif

    call add(l:list, {
      \ 'word': l:word,
      \ 'source': 'hateblo-list',
      \ 'kind': 'file',
      \ 'action__action': 'edit_entry',
      \ 'action__entry_url': l:entry['link'][0]['href'],
      \ 'draft': l:entry['app:control']['app:draft']
      \})
  endfor

  call add(l:list, {
    \ 'word': '### NEXT PAGE ###',
    \ 'source': 'hateblo-list',
    \ 'kind': 'file',
    \ 'action__action': 'next_page',
    \})
  return l:list
endfunction

function! hateblo#entry#getCategories(entry)
  let l:categories = []
  for l:category in a:entry['category']
    call add(l:categories, l:category['term'])
  endfor
  return l:categories
endfunction

