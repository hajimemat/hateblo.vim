" 編集
function! hateblo#editor#edit(entry_url)
  let l:entry = webapi#atom#getEntry(a:entry_url, g:hateblo_vim['user'],g:hateblo_vim['api_key'])
  let l:type = 'html'
  execute 'edit hateblo:'.fnameescape(l:entry['title'])
  execute ":%d"
  let b:entry_url = a:entry_url
  let b:entry_is_new = 0
  call append(0, hateblo#editor#buildFirstLine(l:entry['title'],hateblo#entry#getCategories(l:entry)))
  call append(2, split(l:entry['content'], '\n'))
  execute ":2"
  echom l:entry['content.type']
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
  return "# [".join(l:categories, ',')."] ".a:title
endfunction

" 保存
function! hateblo#editor#save()
  let l:data = hateblo#editor#parseFirstLine(getline(1))

  let l:categories = l:data['categories']
  let l:title = l:data['title']
  let l:contents = join(getline(3,'$'), "\n")

  if b:entry_is_new == 1
    echom "Creating...."
    call webapi#atom#createEntry(
      \ hateblo#webapi#getEntryEndPoint(),
      \ g:hateblo_vim['user'],
      \ g:hateblo_vim['api_key'],
      \ {
      \   'title': l:title,
      \   'content': l:contents,
      \   'content.type': 'text/plain',
      \   'content.mode': '',
      \   'app:control': {
      \     'app:draft': 'yes'
      \   },
      \   'category': l:categories
      \ })
    echom "Created"
    Unite hateblo-list
  else
    echom "Saving...."
    call webapi#atom#updateEntry(
      \ b:entry_url,
      \ g:hateblo_vim['user'],
      \ g:hateblo_vim['api_key'],
      \ {
      \   'title': l:title,
      \   'content': l:contents,
      \   'content.type': 'text/plain',
      \   'content.mode': '',
      \   'app:control': {
      \     'app:draft': 'yes'
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

