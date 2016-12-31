let s:save_cpo=&cpo
set cpo&vim
" hoge

nmap <leader><leader> :source %<CR>

" はてなブログ
let g:hatena_entry_point = 'https://blog.hatena.ne.jp'

function! plugin#getEndPoint()
  return g:hatena_entry_point.'/'.g:hateblo_vim['user'].'/'.g:hateblo_vim['blog']
endfunction

function! plugin#getEntries()
  let l:api_url = plugin#getEndPoint().'/atom/entry'
  echo l:api_url
  let l:feed = webapi#atom#getFeed(l:api_url, g:hateblo_vim['user'],g:hateblo_vim['api_key'])
  let b:entries = l:feed['entry']
  return b:entries
endfunction

function! plugin#getCandidates()
  let l:entries = plugin#getEntries()
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

function! plugin#editEntry(entry_url)
  let l:entry = webapi#atom#getEntry(a:entry_url, g:hateblo_vim['user'],g:hateblo_vim['api_key'])
  let l:type = 'html'
  execute 'edit hateblo:'.l:entry['title']
  let b:entry_url = a:entry_url
  let b:entry_is_new = 0
  "echo l:entry
  execute ":%d"
  call append(0, "TITLE=".l:entry['title'])
  call append(1, "CATEGORIES=".join(plugin#getEntryCategory(l:entry),','))
  call append(3, split(l:entry['content'], '\n'))
  execute ":4"
  echo l:entry['content.type']
  if l:entry['content.type']  ==# 'text/x-markdown'
    let l:type = 'markdown'
  elseif l:entry['content.type']  ==# 'text/x-hatena-syntax'
    let l:type = 'hatena'
  endif
  execute 'setlocal filetype='.l:type.'.hateblo'
endfunction


function! plugin#getEntryCategory(entry)
  let l:categories = []
  for l:category in a:entry['category']
    call add(l:categories, l:category['term'])
  endfor
  return l:categories
endfunction

function! plugin#saveEntry()
  let l:title = getline(1)[len('TITLE='):]
  let l:categories = split(getline(2)[len('CATEGORIES='):],',')
  let l:contents = join(getline(3,'$'), "\n")

  if b:entry_is_new == 1
    echo "Creating...."
    call webapi#atom#createEntry(
      \ plugin#getEndPoint().'/atom',
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
    echo "Created"
  else
    echo "Saving...."
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
    echo "Saved"
  endif
  
endfunction

function! plugin#createEntry()
    call webapi#atom#createEntry(
      \ plugin#getEndPoint().'/atom/entry',
      \ g:hateblo_vim['user'],
      \ g:hateblo_vim['api_key'],
      \ {
      \   'title': 'test',
      \   'content': 'aaaa',
      \   'content.type': 'text/plain',
      \   'content.mode': '',
      \   'app:control': {
      \     'app:draft': 'yes'
      \   },
      \   'category': ['web']
      \ })
  return 1
  call append(0, "TITLE=")
  call append(1, "CATEGORIES=")
  let b:entry_is_new=1
  execute 'setlocal filetype=markdowm.hateblo'
endfunction

augroup hateble_env
  autocmd!
  autocmd BufWriteCmd hateblo:* call plugin#onsave()
augroup END

function! plugin#onsave()
  call plugin#saveEntry()
endfunction

function! s:hateblo_settings()
  nmap <leader>u <SID>call plugin#editEntry(b:entry_url)
endfunction

if exists('g:loaded_hajimemat')
  au NoraAutoCmd FileType *.hateblo call s:hateblo_settings()
  let g:loaded_hajimemat = 1
endif

command! -nargs=0 Test call plugin#editEntry(plugin#getCandidates()[0]['entry_url'])
command! -nargs=0 TestUp call plugin#editEntry(b:entry_url)
command! -nargs=0 TestSave call plugin#saveEntry()
command! -nargs=0 TestCreate call plugin#createEntry()
command! -nargs=0 TestS echo plugin#getCandidates()[0]

"nmap <leader>b <SID>call plugin#editEntry(plugin#getCandidates()[0]['entry_url'])<CR>
"call plugin#editEntry(plugin#getCandidates()[0]['entry_url'])
let &cpo = s:save_cpo
unlet s:save_cpo
