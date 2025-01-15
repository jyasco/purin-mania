# 目次
- [サービス名](#-サービス名)
- [サービスの概要](#-サービスの概要)
- [このサービスへの思い・作りたい理由](#-このサービスへの思い・作りたい理由)
- [機能紹介](#-機能紹介)
- [使用技術](#使用技術)
- [画面遷移図](#画面遷移図)
- [ER図](#ER図)
<br>

# サービス名：**PurinMania**
サービスURL：[PurinMania | プリンのレビュー・検索アプリ](https://www.purinmania.com/)
![alt text](app/assets/images/default-ogp-png)
<br>

## ■ サービスの概要
「Purin Mania」は、プリン愛好家のためのレビュー・検索アプリです。
ユーザーはプリンの固さや甘さなどを詳細に評価し、共有できます。
理想のプリンを自分の好みから検索したり、地図上で簡単に見つけることができます。
<br>

## ■ このサービスへの思い・作りたい理由
私はプリンが大好きで、SNSでプリンに関する情報をよく検索しています。
しかし、プリンの「固さ」や「甘さ」などの具体的な指標がわかる投稿が少なく、自分好みのプリンを見つけるのが難しいと感じることが多いです。
そこで、自分の好みに合ったプリンを簡単に見つけられるサービスを作りたいと考えサービスの開発を決意しました。
<br>

## ■ 機能紹介
|ユーザー登録 |ログイン|
|:--:|:--:|
|<a href="https://gyazo.com/4110506a7d839e1983bf953a2b44a1ba"><img src="https://i.gyazo.com/4110506a7d839e1983bf953a2b44a1ba.png" alt="Image from Gyazo" width="400"/></a>|<a href="https://gyazo.com/3ca8736ccac6baa59fcbd26324cd8111"><img src="https://i.gyazo.com/3ca8736ccac6baa59fcbd26324cd8111.gif" alt="Image from Gyazo" width="396"/></a>
|『ユーザー名』『メールアドレス』『パスワード』『確認用パスワード』を入力してユーザー登録を行います。<br>Googleアカウントを用いてGoogleログインを行う事も可能です。|『メールアドレス』『パスワード』を入力してログインを行います。<br>Googleアカウントを用いてGoogleログインを行う事も可能です。|

|トップ画面 |投稿一覧・検索機能|
|:--:|:--:|
|<a href="https://gyazo.com/2862f9e31ada1e0f15772cc7a9726e70"><img src="https://i.gyazo.com/2862f9e31ada1e0f15772cc7a9726e70.gif" alt="Image from Gyazo" width="396"/></a>|<a href="https://gyazo.com/ceb5d76818dcafbe768378b90c88dd4b"><img src="https://i.gyazo.com/ceb5d76818dcafbe768378b90c88dd4b.gif" alt="Image from Gyazo" width="396"/></a>|
|アプリの説明と使える機能を紹介しています。|投稿一覧ページでは店名・エリアのキーワード検索/甘さ・固さ・評価・カテゴリーでの絞り込み検索/甘さ・固さ・評価・投稿日時の並び替え検索も可能です。|

|マップ検索|ルート検索|
|:--:|:--:|
|<a href="https://gyazo.com/f47f408970e85096a5946bacc7a7b4da"><img src="https://i.gyazo.com/f47f408970e85096a5946bacc7a7b4da.gif" alt="Image from Gyazo" width="398"/></a>|<a href="https://gyazo.com/3d7164a1ad6e27e9f34e499345732f5f"><img src="https://i.gyazo.com/3d7164a1ad6e27e9f34e499345732f5f.gif" alt="Image from Gyazo" width="396"/></a>|
|地図上で投稿がピンで表示され、タップするとモーダルで詳細が確認できます。<br>現在地や店名・場所での検索も可能です。|モーダル内の「ルートを検索」ボタンからGooglemapのルート検索ページに遷移できます。|

|投稿詳細|xシェア機能(動的OGP)|
|:--:|:--:|
|<a href="https://gyazo.com/56c09d07e6cc865329aafaa4ba1a9eb2"><img src="https://i.gyazo.com/56c09d07e6cc865329aafaa4ba1a9eb2.gif" alt="Image from Gyazo" width="396"/></a>|<a href="https://gyazo.com/b4e218382bb1d1d581a1b92c9ee6d26c"><img src="https://i.gyazo.com/b4e218382bb1d1d581a1b92c9ee6d26c.gif" alt="Image from Gyazo" width="394"/></a>|
|店名・画像・コメント・固さ・甘さ・評価・住所などプリンの詳細情報を確認できます。|xボタンから投稿をシェアでき、投稿の写真が動的OGPとして表示されます|

|投稿作成|ブックマーク機能|
|:--:|:--:|
|<a href="https://gyazo.com/9a441f5d0d10c4f61aaf28e8e46be63f"><img src="https://i.gyazo.com/9a441f5d0d10c4f61aaf28e8e46be63f.gif" alt="Image from Gyazo" width="398"/></a>|<a href="https://gyazo.com/6b1e6d7a78bd52a2daae602239258c77"><img src="https://i.gyazo.com/6b1e6d7a78bd52a2daae602239258c77.gif" alt="Image from Gyazo" width="398"/></a>|
|住所のオートコンプリートを実装し、店名を入力すると住所が補完されます。<br>甘さ・固さ・評価を直感的に入力できます。<br>カテゴリーで市販を選択したものは住所の入力欄が非表示になります。|投稿をブックマークでき、マイページで後から確認できます。|

|いいね |マイページ|
|:--:|:--:|
|<a href="https://gyazo.com/58463532422bd4ff82c1a953abe42139"><img src="https://i.gyazo.com/58463532422bd4ff82c1a953abe42139.gif" alt="Image from Gyazo" width="398"/></a>|<a href="https://gyazo.com/5d7df4a168126c0bddecc48cff60c57c"><img src="https://i.gyazo.com/5d7df4a168126c0bddecc48cff60c57c.gif" alt="Image from Gyazo" width="398"/></a>|
|投稿にいいねができます。<br>いいね数が表示され、クリックするといいねしたユーザー一覧を確認できます。|マイページで自分の投稿一覧とブックマーク一覧を確認できます。|

## ■ 使用技術
| カテゴリ | 使用技術 |
| --- | --- | 
| バックエンド | Rails 7.1.3.4 (ruby 3.2.3) |
| フロントエンド | Rails 7.1.3.4 / JavaScript |
| CSSフレームワーク | Tailwindcss / daisyUI |
| Web API | Google Maps API（Places API / Maps JavaScript API / Geolocation API）|
| DBサーバー | PostgreSQL |
| ファイルサーバー | AWS S3 |
| アプリケーションサーバー | render |
| バージョン管理ツール | GitHub |
| 開発環境 | Docker |

## ■ 画面遷移図
[リンク](https://www.figma.com/design/rr4YtUJWptHfXsmJmxlNvF/PurinMania?node-id=40-871&node-type=section&t=S2V7ZUh8N1Nv2D4A-0)

## ■ ER図
[![PurinMania](https://i.gyazo.com/0f44ecdd68b84b0272e1785db06f83de.png)](https://gyazo.com/0f44ecdd68b84b0272e1785db06f83de)
詳細は[こちら](https://dbdiagram.io/d/66fa6e4ef9b1444815e145c8)
