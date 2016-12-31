" 編集
function! hateblo#editor#edit(entry_url)
  let l:entry = webapi#atom#getEntry(a:entry_url, g:hateblo['user'],g:hateblo['api_key'])
  let l:type = 'html'
  execute 'edit hateblo:'.fnameescape(l:entry['title'])
  execute ":%d"
  let b:entry_url = a:entry_url
  let b:entry_is_new = 0
  if l:entry['app:control']['app:draft'] == 'yes'
    let b:entry_is_draft = 1
  else
    let b:entry_is_draft = 0
  endif
  call append(0, hateblo#editor#buildFirstLine(l:entry['title'],hateblo#entry#getCategories(l:entry)))
  call append(2, split(l:entry['content'], '\n'))
  execute ":2"
  if l:entry['content.type']  ==# 'text/x-markdown'
    let l:type = 'markdown'
  elseif l:entry['content.type']  ==# 'text/x-hatena-syntax'
    let l:type = 'hatena'
  endif
  execute 'setlocal filetype='.l:type.'.hateblo'
endfunction

" ファーストラインからタイトルとタグを取得する
function! hateblo#editor#parseFirstLine(line)
  let l:matched = matchlist(a:line, '#\s\+\[\(.\+\)\]\s\+\(.\+\)')
  if len(l:matched) < 1
    return []
  endif
  let l:categories = []
  for l:category in split(l:matched[1],',')
    call add(l:categories, hateblo#util#stripWhitespace(substitute(l:category, '^\s*:', '', '')))
  endfor
  let l:title = l:matched[2]
  return {
    \ 'categories': l:categories,
    \ 'title': l:title
    \}
endfunction

" ファーストラインを作成する
function! hateblo#editor#buildFirstLine(title,categories)
  let l:categories = []
  for l:category in a:categories
    call add(l:categories, ":".l:category)
  endfor
  if b:entry_is_draft == 1
    return "# [".join(l:categories, ',')."] ".g:hateblo_draft_marker.a:title
  else
    return "# [".join(l:categories, ',')."] ".a:title
  endif
endfunction

" 保存
function! hateblo#editor#save()
  let l:data = hateblo#editor#parseFirstLine(getline(1))

  let l:categories = l:data['categories']
  let l:title = l:data['title']
  let l:contents = join(getline(3,'$'), "\n")

  if l:title[0:len(g:hateblo_draft_marker)-1] ==# g:hateblo_draft_marker
    let l:title = l:title[len(g:hateblo_draft_marker):]
    let l:is_draft = 'yes'
  else
    let l:is_draft = 'no'
  endif

  if b:entry_is_new == 1
    call webapi#atom#createEntry(
      \ hateblo#webapi#getEntryEndPoint(),
      \ g:hateblo['user'],
      \ g:hateblo['api_key'],
      \ {
      \   'title': l:title,
      \   'content': l:contents,
      \   'content.type': 'text/plain',
      \   'content.mode': '',
      \   'app:control': {
      \     'app:draft': l:is_draft,
      \   },
      \   'category': l:categories
      \ })
    echom "Created"
    execute(":q!")
    call hateblo#entry#getEntries()
    Unite hateblo-list
  else
    call webapi#atom#updateEntry(
      \ b:entry_url,
      \ g:hateblo['user'],
      \ g:hateblo['api_key'],
      \ {
      \   'title': l:title,
      \   'content': l:contents,
      \   'content.type': 'text/plain',
      \   'content.mode': '',
      \   'app:control': {
      \     'app:draft': l:is_draft,
      \   },
      \   'category': l:categories
      \ })
    echom "Saved"
  endif
  
endfunction

function! hateblo#editor#create()
  let l:data = {}
  let l:data['title'] = input('TITLE: ')
  if len(l:data['title']) < 1
    echom 'Canceled'
    return 0
  endif
  let l:data['categories'] = split(input('CATEGORIES: '),',')
  execute 'tabe hateblo:'.fnameescape(l:data['title'])
  let b:entry_is_draft = 1
  call append(0, hateblo#editor#buildFirstLine(l:data['title'], l:data['categories']))
  " let l:data = hateblo#editor#parseFirstLine(getline(1))
  " if len(l:data) < 1
  "   let l:data = {}
  "   let l:data['title'] = input('TITLE: ')
  "   if len(l:data['title']) < 1
  "     echom 'Canceled'
  "     return 0
  "   endif
  "   let l:data['categories'] = split(input('CATEGORIES: '),',')
  "   execute 'tabe hateblo:'.fnameescape(l:data['title'])
  "   call append(0, hateblo#editor#buildFirstLine(l:data['title'], l:data['categories']))
  " else
  "   execute 'tabe hateblo:'.fnameescape(l:data['title'])
  "   call append(0, getline(0,'$'))
  " endif

  let b:entry_is_new=1
  execute 'setlocal filetype=markdowm.hateblo'
endfunction

