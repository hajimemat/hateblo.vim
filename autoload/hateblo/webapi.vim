" はてなブログ
let g:hateblo = {
      \ 'entry_point': 'https://blog.hatena.ne.jp',
      \ 'user': 'USERID',
      \ 'blog': 'BLOGNAME',
      \ 'api_key': 'APIKEY'
      \ } 

" エントリポイントを取得する
function! hateblo#webapi#getEndPoint()
  return g:hateblo['entry_point']
    \ .'/'
    \ .g:hateblo['user']
    \ .'/'
    \ .g:hateblo['blog']
endfunction

" 記事用のエントリポイントを取得する
function! hateblo#webapi#getEntryEndPoint()
  return hateblo#webapi#getEndPoint()
    \ .'/atom/entry'
endfunction

