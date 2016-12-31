" エントリの処理

" エントリ一覧を取得する
function! hateblo#entry#getEntries()
  return hateblo#entry#getEntriesWithURL(hateblo#webapi#getEntryEndPoint())
endfunction

function! hateblo#entry#getEntriesWithURL(api_url)
  let l:feed = webapi#atom#getFeed(a:api_url, g:hateblo['user'],g:hateblo['api_key'])
  let b:hateblo_entries = l:feed['entry']
  let b:hateblo_next_link = ''
  for l:link in l:feed['link']
    if l:link['rel'] == 'next'
      let b:hateblo_next_link = l:link['href']
    endif
  endfor
  return b:hateblo_entries
endfunction


function! hateblo#entry#getList()
  if !exists('b:hateblo_entries')
    call hateblo#entry#getEntries()
  endif

  let l:entries = b:hateblo_entries
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

  if b:hateblo_next_link != ''
    call add(l:list, {
      \ 'word': '### NEXT PAGE ###',
      \ 'source': 'hateblo-list',
      \ 'kind': 'file',
      \ 'action__action': 'next_page',
      \ 'action__url': b:hateblo_next_link
      \})
  endif

  call add(l:list, {
    \ 'word': '### NEW ###',
    \ 'source': 'hateblo-list',
    \ 'kind': 'file',
    \ 'action__action': 'new',
    \})

  call add(l:list, {
    \ 'word': '### Reflesh ###',
    \ 'source': 'hateblo-list',
    \ 'kind': 'file',
    \ 'action__action': 'reflesh',
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

