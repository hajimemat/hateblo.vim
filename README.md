## 概要

VIMでメモをよく取る、このノリでブログを書きたい。
調べてみると、すでに*はてなブログ*へ投稿するプラグインは存在する。

しかし、この仕組みは自作できるようになっていれば、他の開発でも役に立つはずと考え
自作してみることにした。ちなみに初vimscript。

行った調査は以下。

1. vimとはてなブログはどうつながるか
    1. 通信仕様 [AtomPub](http://developer.hatena.ne.jp/ja/documents/blog/apis/atom)
    1. 認証仕様 [WSSE](http://developer.hatena.ne.jp/ja/documents/auth/apis/wsse)
1. vimでどう実現するか
    1. 通信ツール [math/webapi-vim](https://github.com/mattn/webapi-vim)
1. 参考にしたスクリプト
    1. 既存のツール [moznion/hateblo.vim](https://github.com/moznion/hateblo.vim)

### わかったこと

webapi-vimを使うとAtomPubのAPIと通信ができる。
HTTPリクエストを行い、XMLレスポンスをパースし、vimscript内で配列として受け取れる。

こんなスクリプトを書いて確認
```vim
api_url = &quot;エントリポイント&quot;
user = &quot;はてなID&quot;
api_key = &quot;はてなAPIKEY
echo webapi#atom#getFeed(api_url, user,api_key)
```


## 作るもの
これから作るものの仕様を考えてみた

- インターフェイスはuniteを使う
- 通常のVIMの編集作業と変わるようなコマンド、ショートカットは使わない
- VIMの保存 = サーバへの送信としたい
- 削除機能は実装しない
- 編集書式は常にMarkdownとする

### コマンド

|モード|CMD|-|
|:--:|:--|:--|
|ex|:Unite hateblo-list|記事一覧を表示する+新規作成ができる|
|ex|:w|サーバにデータを保存する|

### 書式

1行目にタグ、タイトルを記述する。
未公開の場合はタイトルの前にD:が表示される。
公開させるにはD:を削除して保存する。

```markdown
# [:tag1,:tag2] タイトル
# [:tag1,:tag2] D:タイトル
```

### セッティング

```vim
let g:hateblo_settings = {
\ 'user': 'はてなID',
\ 'blog': 'はてなブログID',
\ 'api_key': 'APIキー',
\ }
```

### 新規作成
Uniteで起動したリストからNewを選択。
プロンプトでタイトルとカテゴリが聞かれる

以下のように入力
```vim
TITLE: タイトル
CATEGORIES: cat,cat2
```

保存で送信はされるが、送信されたデータのentry_urlが取れなかったので、
一度保存したら、Uniteから再び開いて編集モードで送信しないと、
新規記事が何個もできてしまう。。。


## ソースコード一式

- plugin/plugin.vim
- autoload/hateblo/webapi.vim
- autoload/hateblo/util.vim
- autoload/hateblo/entry.vim
- autoload/hateblo/editor.vim
- autoload/unite/sources/hateblo_list.vim
