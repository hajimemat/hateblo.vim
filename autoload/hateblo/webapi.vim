" はてなブログ
let g:hateblo = {
      \ 'entry_point': 'https://blog.hatena.ne.jp',
      \ 'user': 'kurari0118',
      \ 'blog': 'hajime-mat.hateblo.jp',
      \ 'api_key': 'k1kcgqc81j'
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

